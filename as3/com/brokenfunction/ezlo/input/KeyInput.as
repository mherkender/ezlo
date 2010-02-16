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
package com.brokenfunction.ezlo.input {
	import com.brokenfunction.ezlo.*;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	public class KeyInput implements Input {
		private var dispatch:EventDispatcher;
		private var now:uint = 0;
		private var keys:Object = {};

		public function KeyInput(keyDispatcher:EventDispatcher) {
			dispatch = keyDispatcher;
			dispatch.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			dispatch.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			dispatch.addEventListener(Event.DEACTIVATE, onSourceDeactivate);
		}
		public function destroy():void {
			dispatch.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			dispatch.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			dispatch.removeEventListener(Event.DEACTIVATE, onSourceDeactivate);
			dispatch = null;
		}
		public function get inputValue():uint {
			return now;
		}
		private function onKeyDown(e:KeyboardEvent):void {
			now |= uint(keys[e.keyCode] || 0);
		}
		private function onKeyUp(e:KeyboardEvent):void {
			now &= ~uint(keys[e.keyCode] || 0);
		}
		private function onSourceDeactivate(e:Event):void {
			now = 0;
		}
		public function setKey(b:uint, k:uint):void {
			keys[k] = b;
		}
		public function addKey(b:uint, k:uint):void {
			if (keys[k]) {
				keys[k] |= b;
			} else {
				keys[k] = b;
			}
		}
		public function resetKeys():void {
			keys = {};
		}
	}
}
