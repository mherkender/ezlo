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
	import flash.display.Shape;
	import flash.utils.Dictionary;

	public class CrashService implements CollideService {
		private var groups:Object = {};
		private var watchers:Dictionary = new Dictionary();
		private var debugShape:Shape;

		public function CrashService(debugMode:Boolean = false) {
			if (debugMode) debugShape = new Shape();
		}
		public function destroy():void {
			// todo
		}
		public function get debugLayer():DisplayObject {return debugShape;}

		private function getGroup(group:String):CrashServiceGroup {
			return (groups[group] is CrashServiceGroup ?
				groups[group] as CrashServiceGroup :
				(groups[group] = new CrashServiceGroup(group, Boolean(debugShape))));
		}
		public function groupBoundary(group:String, obj:Object, bounds:Boundary):void {
			getGroup(group).groupBoundary(obj, bounds);
		}
		public function ungroupBoundary(group:String, obj:Object):void {
			var groupInstance:CrashServiceGroup = getGroup(group);
			groupInstance.ungroupBoundary(obj);
			if (groupInstance.isEmpty) delete groups[group];
		}
		public function checkGroup(group:String, against:Boundary, require:uint, callback:Function):void {
			getGroup(group).checkGroup(against, require, callback);
		}

		private function getWatcher(boundary:Boundary):CrashServiceWatcher {
			return (watchers[boundary] is CrashServiceWatcher ?
				watchers[boundary] as CrashServiceWatcher :
				(watchers[boundary] = new CrashServiceWatcher(boundary)));
		}
		public function watchBoundary(boundary:Boundary, callback:Function, x1:Number, y1:Number, x2:Number, y2:Number, require:uint = 0):uint {
			return getWatcher(boundary).watchBoundary(callback, x1, y1, x2, y2, require);
		}
		public function unwatchBoundary(boundary:Boundary, callback:Function):void {
			var watcher:CrashServiceWatcher = getWatcher(boundary);
			watcher.unwatchBoundary(callback);
			if (watcher.isEmpty) delete watchers[boundary];
		}
		public function process():void {
			for each (var watcher:CrashServiceWatcher in watchers) {
				watcher.process();
			}
		}

		public function drawBoundaries():void {
			if (debugShape) {
				debugShape.graphics.clear();
				for each (var group:CrashServiceGroup in groups) {
					group.drawBoundaries(debugShape.graphics);
				}
			}
		}
	}
}
