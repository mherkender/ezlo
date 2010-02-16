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
package com.brokenfunction.ezlo.move {
	import com.brokenfunction.ezlo.*;

	public class EventValue implements MovementValue {
		private var _value:uint;
		private var onTrigger:Function;

		public function EventValue(val:uint, callback:Function) {
			_value = val;
			onTrigger = callback;
		}
		public function get value():uint {
			return _value;
		}
		public function intersect(bits:uint, obj:Object):uint {
			if (((bits &= _value) & 0xf000) !== 0) {
				//trace("intersect <"+obj+"> w/ <"+this+">");
				onTrigger(obj);
			}
			return bits;
		}
		public function hover(bits:uint, obj:Object):void {
			if ((bits & _value & 0x0f00) !== 0) {
				//trace("hover <"+obj+"> w/ <"+this+">");
				onTrigger(obj);
			}
		}
	}
}
