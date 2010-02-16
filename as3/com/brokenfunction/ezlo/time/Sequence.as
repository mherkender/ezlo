/*
 * Copyright 2005, 2006, 2007, 2008, 2009, 2010 Maximilian Herkender
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.brokenfunction.ezlo.time {
	import com.brokenfunction.ezlo.*;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Sequence {
		private var _timeService:TimeService;
		private var _fps:uint;
		private var _priority:uint;
		private var _position:uint = 0;
		private var playing:Boolean = false;
		private var lastKeyframe:uint = 0;
		private var triggers:Array = [];
		private var ranges:Array = [];
		private var pauses:Array = [];

		public function Sequence(timeService:TimeService, fps:uint, priority:uint = 0) {
			_timeService = timeService;
			_fps = fps;
			_priority = priority;
		}
		public function destroy():void {
			stop();
		}

		// fundamental methods
		public function keyframe(offset:uint):void {
			if (uint(lastKeyframe + offset) < lastKeyframe) {
				lastKeyframe = uint.MAX_VALUE;
			} else {
				lastKeyframe += offset;
			}
		}
		public function trigger(callback:Function, offset:uint = 0):void {
			var entry:Trigger = new Trigger();
			entry.position = lastKeyframe + offset;
			entry.callback = callback;
			if (entry.position < lastKeyframe) entry.position = uint.MAX_VALUE;

			// log(n) add
			var i:uint = 0, n:uint = findFirstBit(triggers.length);
			do {
				if ((n | i) <= triggers.length && (triggers[(n | i)-1] as Trigger).position > entry.position) i |= n;
			} while (n >>>= 1);
			triggers.splice(i, 0, entry);
		}
		public function range(callback:Function, start:uint = 0, end:uint = uint.MAX_VALUE):void {
			if (start >= end) throw new Error("start <" + start + "> must be less than end <" + end + ">");
			var entry:Range = new Range();
			entry.start = lastKeyframe + start;
			entry.end = lastKeyframe + end;
			entry.callback = callback;
			if (entry.start < lastKeyframe) entry.start = uint.MAX_VALUE;
			if (entry.end < lastKeyframe) entry.end = uint.MAX_VALUE;

			// log(n) add
			var i:uint = 0, n:uint = findFirstBit(triggers.length);
			do {
				if ((n | i) <= ranges.length && (ranges[(n | i)-1] as Range).start > entry.start) i |= n;
			} while (n >>>= 1);
			ranges.splice(i, 0, entry);
		}
		private function findFirstBit(x:uint):uint {
			// modified from Hacker's Delight code
			// http://www.hackersdelight.org/HDcode/nlz.c
			var n:uint = 0x80000000;
			if (x <= 0x0000FFFF) {n = n >>>16; x = x <<16;}
			if (x <= 0x00FFFFFF) {n = n >>> 8; x = x << 8;}
			if (x <= 0x0FFFFFFF) {n = n >>> 4; x = x << 4;}
			if (x <= 0x3FFFFFFF) {n = n >>> 2; x = x << 2;}
			if (x <= 0x7FFFFFFF) {n = n >>> 1;}
			return n;
		}

		// additional methods
		public function fadeOutCustom(callback:Function, start:uint, end:uint):void {
			var width:uint = end - start;
			range(function (position:uint):void {
				callback((width - position) / width);
			}, start, end);
		}
		public function fadeInCustom(callback:Function, start:uint, end:uint):void {
			range(function (position:uint):void {
				callback((position - start) / (end - start));
			}, start, end);
		}
		public function fadeOut(displayObject:DisplayObject, start:uint, end:uint):void {
			var width:uint = end - start;
			range(function (position:uint):void {
				displayObject.alpha = (width - position) / width;
			}, start, end);
		}
		public function fadeIn(displayObject:DisplayObject, start:uint, end:uint):void {
			range(function (position:uint):void {
				displayObject.alpha = (position - start) / (end - start);
			}, start, end);
		}
		public function drawFrame(frameset:Frameset, row:uint, frame:uint, offset:uint = 0):void {
			trigger(function ():void {
				frameset.drawFrame(row, frame);
			}, offset);
		}
		public function setVisibility(displayObject:DisplayObject, visible:Boolean, offset:uint = 0):void {
			trigger(function ():void {
				displayObject.visible = visible;
			}, offset);
		}

		// playback
		public function play():void {
			if (!playing) {
				playing = true;
				_timeService.addTimeListener(onTick, _fps, _priority);
				process();
			}
		}
		public function stop():void {
			_position = uint.MAX_VALUE;
			if (!playing) process();
		}
		protected function onTick(e:TimeEvent):void {
			if (playing) {
				_position = (_position > (uint.MAX_VALUE-e.steps) ? uint.MAX_VALUE : (_position+e.steps));
				process();
			}
		}
		protected function process():void {
			var tIndex:uint = triggers.length, rIndex:uint = ranges.length;
			var currentTrigger:Trigger = (tIndex-- > 0 ? triggers[tIndex] as Trigger : null);
			var currentRange:Range = (rIndex-- > 0 ? ranges[rIndex] as Range : null);

			while (currentTrigger || currentRange) {
				if (!currentTrigger || (currentRange && currentRange.start < currentTrigger.position)) {
					if (_position >= currentRange.start) {
						if (_position >= currentRange.end) {
							currentRange.callback(currentRange.end - currentRange.start);
							ranges.splice(rIndex, 1);
						} else {
							currentRange.callback(_position - currentRange.start);
						}
						currentRange = (rIndex-- > 0 ? ranges[rIndex] as Range : null);
					} else break;
				} else {
					if (_position >= currentTrigger.position) {
						if (currentTrigger.callback() && _position !== uint.MAX_VALUE) {
							_position = currentTrigger.position;
						} else {
							triggers.splice(tIndex, 1);
						}
						currentTrigger = (tIndex-- > 0 ? triggers[tIndex] as Trigger : null);
					} else break;
				}
			}

			if (_position >= lastKeyframe) {
				playing = false;
				_timeService.removeTimeListener(onTick, _fps);
				trace("animation complete <" + this + ">");
			}
		}

		// debug
		public function debugString():String {
			var result:String = "";
			var i:uint = 0;
			while (i < triggers.length) {
				result += triggers[i].position + "\n";
				i++;
			}
			i = 0;
			while (i < ranges.length) {
				result += ranges[i].start + " : " + ranges[i].end + "\n";
				i++;
			}
			return result;
		}
	}
}

class Range {
	public var start:uint;
	public var end:uint;
	public var callback:Function;
}
class Trigger {
	public var position:uint;
	public var callback:Function;
}
