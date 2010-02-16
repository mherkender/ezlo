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
package com.brokenfunction.ezlo.collide {
	import com.brokenfunction.ezlo.*;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/*
		NOTE: It's untested, but this service should work recursively.
		NOTE: The search per process() call is O(log(n)), but it could be O(1)
	*/
	public class CrashServiceWatcher {
		static private function doNothing(bits:int):void {}

		private var _bounds:Boundary;
		private var maxBit:int = 1;
		private var lastX1:Number;
		private var lastY1:Number;
		private var lastX2:Number;
		private var lastY2:Number;
		private var lx1:Array = [];
		private var ly1:Array = [];
		private var lx2:Array = [];
		private var ly2:Array = [];
		private var dictCache:Dictionary;
		private var backtrace:Dictionary = new Dictionary(false);

		public function CrashServiceWatcher(bounds:Boundary) {
			_bounds = bounds;
			lastX1 = _bounds.x1;
			lastY1 = _bounds.y1;
			lastX2 = _bounds.x2;
			lastY2 = _bounds.y2;
		}
		public function get isEmpty():Boolean {
			return (!lx1.length || !ly1.length || !lx2.length || !ly2.length);
		}

		public function checkMaxBit(l:uint):void {
			if ((l & (maxBit | maxBit-1)) !== l) maxBit <<= 1;
		}
		public function watchBoundary(callback:Function, x1:Number, y1:Number, x2:Number, y2:Number, require:uint = 0):uint {
			unwatchBoundary(callback);
			var entry:Entry = backtrace[callback] = new Entry(callback);
			entry.x1 = x1;
			entry.y1 = y1;
			entry.x2 = x2;
			entry.y2 = y2;
			entry.require = require;

			if (!isNaN(x2)) lx1.splice(findInX1(x2), 0, entry);
			if (!isNaN(y2)) ly1.splice(findInY1(y2), 0, entry);
			if (!isNaN(x1)) lx2.splice(findInX2(x1), 0, entry);
			if (!isNaN(y1)) ly2.splice(findInY2(y1), 0, entry);
			checkMaxBit(Math.max(lx1.length, ly1.length, lx2.length, ly2.length));

			entry.bits =
				((lastY1 <  y2)? 0x1 :0) |
				((lastX2 >= x1)? 0x2 :0) |
				((lastY2 >= y1)? 0x4 :0) |
				((lastX1 <  x2)? 0x8 :0);
			return entry.bits;
		}
		public function unwatchBoundary(callback:Function):void {
			var entry:Entry = backtrace[callback];
			if (entry) entry.callback = doNothing;
		}
		public function process():void {
			var index:uint, entry:Entry;
			var update:Dictionary = dictCache;
			if (!update) update = new Dictionary(true);
			dictCache = null;

			// x1
			if (_bounds.x1 != lastX1) {
				index = findInX1(lastX1);
				if (_bounds.x1 < lastX1) {// 0|011 -> 0|111
					while (index-- > 0 && _bounds.x1 < (entry = lx1[index]).x2) {
						if (entry.callback === doNothing) {
							trace("rm x1 "+entry.x2);
							lx1.splice(index, 1);
						} else {
							trace("x1+ "+entry.x2);
							entry.bits |= 0x8;
							update[entry] = entry;
						}
					}
				} else {// 001|1 -> 000|1
					while (index < lx1.length && _bounds.x1 >= (entry = lx1[index]).x2) {
						if (entry.callback === doNothing) {
							trace("rm x1 "+entry.x2);
							lx1.splice(index, 1);
						} else {
							trace("x1- "+entry.x2);
							entry.bits &= ~0x8;
							update[entry] = entry;
							index++;
						}
					}
				}
				lastX1 = _bounds.x1;
			}

			// y1
			if (_bounds.y1 != lastY1) {
				index = findInY1(lastY1);
				if (_bounds.y1 < lastY1) {// 0|011 -> 0|111
					while (index-- > 0 && _bounds.y1 < (entry = ly1[index]).y2) {
						if (entry.callback === doNothing) {
							trace("rm y1 "+entry.y2);
							ly1.splice(index, 1);
						} else {
							trace("y1+ "+entry.y2);
							entry.bits |= 0x1;
							update[entry] = entry;
						}
					}
				} else {// 001|1 -> 000|1
					while (index < ly1.length && _bounds.y1 >= (entry = ly1[index]).y2) {
						if (entry.callback === doNothing) {
							trace("rm y1 "+entry.y2);
							ly1.splice(index, 1);
						} else {
							trace("y1- "+entry.y2);
							entry.bits &= ~0x1;
							update[entry] = entry;
							index++;
						}
					}
				}
				lastY1 = _bounds.y1;
			}

			// x2
			if (_bounds.x2 != lastX2) {
				index = findInX2(lastX2);
				if (_bounds.x2 < lastX2) {// 1|100 -> 1|000
					while (index-- > 0 && _bounds.x2 <= (entry = lx2[index]).x1) {
						if (entry.callback === doNothing) {
							trace("rm x2 "+entry.x1);
							lx2.splice(index, 1);
						} else {
							trace("x2- "+entry.x1);
							entry.bits &= ~0x2;
							update[entry] = entry;
						}
					}
				} else {// 110|0 -> 111|0
					while (index < lx2.length && _bounds.x2 > (entry = lx2[index]).x1) {
						if (entry.callback === doNothing) {
							trace("rm x2 "+entry.x1);
							lx2.splice(index, 1);
						} else {
							trace("x2+ "+entry.x1);
							entry.bits |= 0x2;
							update[entry] = entry;
							index++;
						}
					}
				}
				lastX2 = _bounds.x2;
			}

			// y2
			if (_bounds.y2 != lastY2) {
				index = findInY2(lastY2);
				if (_bounds.y2 < lastY2) {// 1|100 -> 1|000
					while (index-- > 0 && _bounds.y2 <= (entry = ly2[index]).y1) {
						if (entry.callback === doNothing) {
							trace("rm y2 "+entry.y1);
							ly2.splice(index, 1);
						} else {
							trace("y2- "+entry.y1);
							entry.bits &= ~0x4;
							update[entry] = entry;
						}
					}
				} else {// 110|0 -> 111|0
					while (index < ly2.length && _bounds.y2 > (entry = ly2[index]).y1) {
						if (entry.callback === doNothing) {
							trace("rm y2 "+entry.y1);
							ly2.splice(index, 1);
						} else {
							trace("y2+ "+entry.y1);
							entry.bits |= 0x4;
							update[entry] = entry;
							index++;
						}
					}
				}
				lastY2 = _bounds.y2;
			}

			for each (entry in update) {
				if ((entry.bits & entry.require) === entry.require) {
					entry.callback(entry.bits);
				}
				delete update[entry];
			}

			dictCache = update;
		}
		private function findInX1(x:Number):uint {
			var i:uint = 0, n:uint = maxBit;
			do {
				if ((n | i) <= lx1.length && (lx1[(n | i)-1] as Entry).x2 <= x) i |= n;
			} while (n >>>= 1);
			return i;
		}
		private function findInY1(y:Number):uint {
			var i:uint = 0, n:uint = maxBit;
			do {
				if ((n | i) <= ly1.length && (ly1[(n | i)-1] as Entry).y2 <= y) i |= n;
			} while (n >>>= 1);
			return i;
		}
		private function findInX2(x:Number):uint {
			var i:uint = 0, n:uint = maxBit;
			do {
				if ((n | i) <= lx2.length && (lx2[(n | i)-1] as Entry).x1 < x) i |= n;
			} while (n >>>= 1);
			return i;
		}
		private function findInY2(y:Number):uint {
			var i:uint = 0, n:uint = maxBit;
			do {
				if ((n | i) <= ly2.length && (ly2[(n | i)-1] as Entry).y1 < y) i |= n;
			} while (n >>>= 1);
			return i;
		}
	}
}

class Entry {
	public var bits:uint = 0;
	public var require:uint;
	public var x1:Number;
	public var y1:Number;
	public var x2:Number;
	public var y2:Number;
	public var callback:Function;
	public function Entry(t:Function) {
		callback = t;
	}
}
