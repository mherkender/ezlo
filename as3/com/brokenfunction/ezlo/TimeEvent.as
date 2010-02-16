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
package com.brokenfunction.ezlo {
	import flash.events.Event;

	public class TimeEvent extends Event {
		private var _steps:uint;
		private var _time:uint;
		private var _subSteps:Number;

		public function TimeEvent(type:String, steps:uint, time:uint, subSteps:Number, cancelable:Boolean = false) {
			super(type, false, cancelable);
			_steps = steps;
			_time = time;
			_subSteps = subSteps;
		}

		public override function clone():Event {
			return new TimeEvent(type, steps, time, subSteps, cancelable);
		}
		public override function toString():String {
			return "[TimeEvent type="+type+" steps="+steps+" time="+time+" subSteps="+subSteps+" cancelable="+cancelable+"]";
		}

		public function get steps():uint {return _steps;}
		public function get time():uint {return _time;}
		public function get subSteps():Number {return _subSteps;}
	}
}
