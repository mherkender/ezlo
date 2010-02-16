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
	import com.brokenfunction.ezlo.geom.StaticBoundary;

	import flash.display.Graphics;
	import flash.utils.Dictionary;

	public class CrashServiceGroup {
		private var _groupName:String;
		private var _boundaryLogging:Boolean = false;
		private var objects:Dictionary = new Dictionary();
		private var debugGroupA:Dictionary = new Dictionary(true);
		private var debugGroupB:Dictionary = new Dictionary(true);

		public function CrashServiceGroup(groupName:String, boundaryLogging:Boolean) {
			_groupName = groupName;
			_boundaryLogging = boundaryLogging;
		}
		public function destroy():void {
			// todo
		}
		public function get isEmpty():Boolean {
			return (objects.length > 0);
		}

		public function groupBoundary(obj:Object, bounds:Boundary):void {
			if (obj == null) throw new Error("obj <" + obj + "> cannot be null");

			if (obj in objects) {
				trace("warning: object <" + obj + "> cannot have more than one entry in group <" + _groupName + ">");
			}
			objects[obj] = bounds;
		}
		public function ungroupBoundary(obj:Object):void {
			if (obj == null) throw new Error("obj <" + obj + "> cannot be null");

			if (obj in objects) {
				delete objects[obj];
			} else {
				trace("warning: object <" + obj + "> was not in <" + _groupName + ">");
			}
		}
		public function checkGroup(against:Boundary, require:uint, callback:Function):void {
			if (_boundaryLogging && against) {
				debugGroupA[against] = StaticBoundary.createDuplicate(against);
			}

			var bounds:Boundary, obj:Object;
			if (require) {
				if (against) {
					for (obj in objects) {
						if ((bounds = objects[obj]) && ((
							(against.y1 <= bounds.y2 ? 0x1 : 0) |
							(against.x2 >= bounds.x1 ? 0x2 : 0) |
							(against.y2 >= bounds.y1 ? 0x4 : 0) |
							(against.x1 <= bounds.x2 ? 0x8 : 0)) & require) === require) {
							callback(obj, bounds);
						}
					}
				}
			} else {
				for (obj in objects) {
					if ((bounds = objects[obj])) {
						callback(obj, bounds);
					}
				}
			}
		}

		public function drawBoundaries(graphics:Graphics):void {
			var bounds:Boundary;
			for (var obj:Object in objects) if ((bounds = objects[obj])) {
				debugGroupB[bounds] = StaticBoundary.createDuplicate(bounds);
			}

			var copy:Boundary;
			for (var boundB:* in debugGroupB) {
				copy = debugGroupB[boundB];
				delete debugGroupB[boundB];
				graphics.lineStyle(0, 0x00ff00, 0);
				graphics.beginFill(0x00ff00, 0.5);
				graphics.drawRect(
					copy.x1,
					copy.y1,
					copy.x2 - copy.x1,
					copy.y2 - copy.y1);
				graphics.endFill();
			}
			for (var boundA:* in debugGroupA) {
				copy = debugGroupA[boundA];
				delete debugGroupA[boundA];
				graphics.lineStyle(0, 0xff0000);
				graphics.beginFill(0xff0000, 0);
				graphics.drawRect(
					copy.x1,
					copy.y1,
					copy.x2 - copy.x1,
					copy.y2 - copy.y1);
				graphics.endFill();
			}
		}
	}
}
