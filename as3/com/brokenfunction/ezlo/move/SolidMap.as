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
﻿package com.brokenfunction.ezlo.move {
	import com.brokenfunction.ezlo.*;
	import com.brokenfunction.ezlo.geom.ControlledBoundary;
	import com.brokenfunction.ezlo.geom.DifferenceBoundary;

	public class SolidMap implements MovementMap {
		private var _value:MovementValue;
		private var _boundry:Boundary;
		private var _boundryPrev:ControlledBoundary = new ControlledBoundary();
		private var _change:DifferenceBoundary;
		private var prevX1:Number;
		private var prevY1:Number;
		private var prevX2:Number;
		private var prevY2:Number;
		private var prevFX:Number;
		private var prevFY:Number;

		public function SolidMap(value:MovementValue, boundry:Boundary) {
			_value = value;
			bounds = boundry;
			resetMovement();
		}
		public function resetMovement():void {
			_boundryPrev.copy(_boundry);
		}
		public function get bounds():Boundary {return _boundry;}
		public function set bounds(b:Boundary):void {
			_boundry = b;
			_change = new DifferenceBoundary(_boundry, _boundryPrev);
		}
		public function get change():Boundary {return _change;}

		public function checkMoveDown(change:Boundary, obj:Object, flags:uint = 0):uint {
			// from above
			if (change.y1 <= _boundry.y1 && change.y2 >= _boundry.y1 && change.x2 > _boundry.x1 && change.x1 < _boundry.x2) {
				var result:uint = _value.intersect(flags, obj);
				if (result & 0x1) {
					change.y2 = _boundry.y1;
					return result;
				}
			}
			return 0;
		}
		public function checkMoveUp(change:Boundary, obj:Object, flags:uint = 0):uint {
			// from below
			if (change.y1 <= _boundry.y2 && change.y2 >= _boundry.y2 && change.x2 > _boundry.x1 && change.x1 < _boundry.x2) {
				var result:uint = _value.intersect(flags, obj);
				if (result & 0x4) {
					change.y1 = _boundry.y2;
					return result;
				}
			}
			return 0;
		}

		public function checkMoveLeft(change:Boundary, obj:Object, flags:uint = 0):uint {
			// from right
			if (change.x1 <= _boundry.x2 && change.x2 >= _boundry.x2 && change.y2 > _boundry.y1 && change.y1 < _boundry.y2) {
				var result:uint = _value.intersect(flags, obj);
				if (result & 0x2) {
					change.x1 = _boundry.x2;
					return result;
				}
			}
			return 0;
		}
		public function checkMoveRight(change:Boundary, obj:Object, flags:uint = 0):uint {
			// from left
			if (change.x1 <= _boundry.x1 && change.x2 >= _boundry.x1 && change.y2 > _boundry.y1 && change.y1 < _boundry.y2) {
				var result:uint = _value.intersect(flags, obj);
				if (result & 0x8) {
					change.x2 = _boundry.x1;
					return result;
				}
			}
			return 0;
		}
		public function checkPoint(pos:Position, triggee:Object, flags:uint = 0):uint {
			// TODO
			return 0;
		}
	}
}
