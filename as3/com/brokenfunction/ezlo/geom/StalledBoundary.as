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
package com.brokenfunction.ezlo.geom {
	import com.brokenfunction.ezlo.*;

	public class StalledBoundary implements Boundary {
		private var _x1:int;
		private var _y1:int;
		private var _x2:int;
		private var _y2:int;
		private var subBoundary:Boundary;

		public function StalledBoundary(x1:int, y1:int, x2:int, y2:int, boundry:Boundary) {
			subBoundary = boundry;
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
		}

		public function get fX():Number {return subBoundary.fX;}
		public function get fY():Number {return subBoundary.fY;}
		public function get x1():Number {return subBoundary.x1;}
		public function get y1():Number {return subBoundary.y1;}
		public function get x2():Number {return subBoundary.x2;}
		public function get y2():Number {return subBoundary.y2;}

		public function set fX(x:Number):void {
			var a:Number = subBoundary.fX;
			if (a > x-_x1) {
				subBoundary.fX = x-_x1;
			} else if (a < x-_x2) {
				subBoundary.fX = x-_x2;
			}
		}
		public function set fY(y:Number):void {
			var b:Number = subBoundary.fY;
			if (b > y-_y1) {
				subBoundary.fY = y-_y1;
			} else if (b < y-_y2) {
				subBoundary.fY = y-_y2;
			}
		}
		public function set x1(x:Number):void {subBoundary.x1 = x;}
		public function set y1(y:Number):void {subBoundary.y1 = y;}
		public function set x2(x:Number):void {subBoundary.x2 = x;}
		public function set y2(y:Number):void {subBoundary.y2 = y;}

		public function move(x:Number, y:Number):void {
			subBoundary.move(x, y);
		}
	}
}
