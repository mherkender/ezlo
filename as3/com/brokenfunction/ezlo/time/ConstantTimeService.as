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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ConstantTimeService implements TimeService {
		static private const BASE:String = "base";

		private var dispatch:EventDispatcher;
		private var backtrace:Object = {};
		private var clock:uint = 0;
		private var pastClock:uint = 0;

		private var pauseTimeService:ConstantTimeService;
		private var _onPause:Function;
		private var _onRestore:Function;

		public function ConstantTimeService(onPause:Function = null, onRestore:Function = null, target:IEventDispatcher = null) {
			dispatch = new EventDispatcher(target);
			_onPause = onPause;
			_onRestore = onRestore;
		}

		public function pauseTime():TimeService {
			if (!pauseTimeService) {
				pauseTimeService = new ConstantTimeService();
				if (_onPause != null) _onPause(pauseTimeService);
			}
			return pauseTimeService;
		}
		public function restoreTime():void {
			if (pauseTimeService) {
				pauseTimeService = null;
				if (_onRestore != null) _onRestore(this);
			}
		}

		public function addTimeListener(callback:Function, split:uint = 1000, priority:int = 0, useWeakReference:Boolean = false):uint {
			if (split != int(split)) throw new Error("Split is too high");

			dispatch.addEventListener(String(split), callback, false, priority, useWeakReference);
			if (!(split in backtrace)) {
				dispatch.addEventListener(BASE, backtrace[split] = baseCallback(split), false, split);
			}
			return (clock * split) / 1000;
		}
		public function removeTimeListener(callback:Function, split:uint = 1000):void {
			var type:String = String(split);
			dispatch.removeEventListener(type, callback);
			if (!dispatch.hasEventListener(type) && split in backtrace) {
				dispatch.removeEventListener(BASE, backtrace[split] as Function, false);
				delete backtrace[split];
			}
		}
		public function getTime(split:uint):uint {
			return (clock * split) / 1000;
		}

		private function baseCallback(split:uint):Function {
			var type:String = String(split);
			return function (e:TimeEvent):void {
				var currentTime:uint = (clock * split) / 1000;
				dispatch.dispatchEvent(new TimeEvent(
					type,
					currentTime - uint((pastClock * split) / 1000),
					currentTime,
					(e.steps * split) / 1000,
					e.cancelable));
			};
		}
		public function update(ms:uint):void {
			if (pauseTimeService) {
				dispatch.dispatchEvent(new TimeEvent(BASE, 0, 0, 0, true));
				pauseTimeService.update(ms);
			} else {
				clock += ms;
				dispatch.dispatchEvent(new TimeEvent(BASE, ms, 0, 0, true));
				pastClock = clock;
			}
		}
	}
}
