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
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class AutoTimeService extends ConstantTimeService {
		static private const SLACK:uint = 3;

		private var timer:Timer;
		private var last:uint;
		private var min:uint;
		private var max:uint;

		public function AutoTimeService(maxFps:Number, minFps:Number, onPause:Function = null, onRestore:Function = null, target:IEventDispatcher = null) {
			super(onPause, onRestore, target);
			min = Math.floor(1000 / maxFps);
			max = Math.ceil(1000 / minFps);

			timer = new Timer(1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			last = getTimer();
			timer.start();
		}

		private function onTimer(e:TimerEvent):void {
			var time:uint = getTimer();
			var change:uint = time - last;
			if (change >= min) {
				change += SLACK;
				update(change <= max ? change : max);
				last = time + SLACK;
				timer.delay = SLACK + 1;
				e.updateAfterEvent();
			} else {
				var delay:Number = (min - change) / 2;
				timer.delay = delay ? delay : 1;
			}
		}
	}
}
