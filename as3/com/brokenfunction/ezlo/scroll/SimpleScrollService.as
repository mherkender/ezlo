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
package com.brokenfunction.ezlo.scroll {
	import com.brokenfunction.ezlo.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/*
		TODO: Have the created layers detect when they are moved?
	   TODO: Fix the whole implementation. It blows.
	*/
	public class SimpleScrollService extends Sprite implements ScrollService {
		static private const FIRST_INDEX:int = 0;

		private var groups:Object = {};
		private var groupsIndexed:Array = [];
		private var iterating:Boolean = false;

		public function SimpleScrollService() {
			super();
			var firstLayer:DisplayObjectContainer = createLayer();
			addChild(firstLayer);
			groupsIndexed.push(FIRST_INDEX);
			groups[FIRST_INDEX] = firstLayer;
		}

		protected function forEachLayer(func:Function):void {
			if (iterating) {
				forEachLayer2(func);
			} else {
				iterating = true;
				forEachLayer2(func);
				iterating = false;
			}
		}
		private function forEachLayer2(func:Function):void {
			var index:int;
			var i:int = groupsIndexed.length;
			while (i-- > 0) {
				index = groupsIndexed[i];
				func(groups[index] as DisplayObjectContainer, index);
			}
		}

		public function addChildToLayer(child:DisplayObject, index:int):DisplayObject {
			var result:DisplayObject = getLayer(index).addChild(child);
			//trace(debugInfo);
			return result;
		}
		public function addChildAtLayer(child:DisplayObject, index:int):DisplayObject {
			var result:DisplayObject = addChildAt(child, getChildIndex(getLayer(index)) + 1);
			//trace(debugInfo);
			return result;
		}
		public function getLayer(index:int):DisplayObjectContainer {
			var layer:DisplayObjectContainer = groups[index];
			if (!layer) {
				layer = createLayer();
				if (iterating)
					throw new Error("Modifying the layers whild iterating is not allowed");
				groupsIndexed.push(index);
				groupsIndexed.sort(Array.NUMERIC);
				var newPos:int = groupsIndexed.indexOf(index);
				if (newPos < groupsIndexed.length-1) {
					var nextLayer:DisplayObjectContainer = groups[groupsIndexed[newPos+1]];
					addChildAt(layer, getChildIndex(nextLayer));// add before this one
				} else {
					addChild(layer);// add to end
				}
				groups[index] = layer;
			}
			return layer;
		}
		public override function removeChild(child:DisplayObject):DisplayObject {
			if (child.parent && child.parent.parent == this) {
				// TODO: verify it is in a layer
				try {
					return child.parent.removeChild(child);
				} catch (e:Error) {
					throw new Error("Error while removing child "+ child +" from "+ child.parent +": "+ e.message);
				}
			}
			return super.removeChild(child);
		}
		protected function createLayer():DisplayObjectContainer {
			return new Sprite();
		}

		public function get debugInfo():String {
			var result:String = "";
			var child:DisplayObject;
			var group:DisplayObjectContainer;
			var i:int = 0, j:int;
			while (i < numChildren) {
				child = getChildAt(i);
				result += i + ": ";
				i++;

				if (isGroup(child)) {
					group = child as DisplayObjectContainer;
					result += group + " (group for index " + groupIndex(child) + ")\n";
					j = 0;
					while (j < group.numChildren) {
						result += "\t" + j + ": " + group.getChildAt(j) + "\n";
						j++;
					}
				} else {
					result += child + "\n";
				}
			}
			return result;
		}
		private function isGroup(displayObject:DisplayObject):Boolean {
			for each (var group:* in groups) if (displayObject === group) {
				return true;
			}
			return false;
		}
		private function groupIndex(displayObject:DisplayObject):int {
			for (var index:String in groups) if (displayObject === groups[index]) {
				return int(index);
			}
			return 0;
		}

		public function get scrollBounds():AdjustableBoundary {
			throw new Error("scrollBounds not implemented");
		}
		public function get visibleBounds():Boundary {
			throw new Error("visibleBounds not implemented");
		}
	}
}
