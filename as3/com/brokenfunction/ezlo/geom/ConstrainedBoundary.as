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

	public class ConstrainedBoundary implements Boundary {
		private var sizeX:uint;
		private var sizeY:uint;
		private var x:Number = 0;
		private var y:Number = 0;
		private var boundry:Boundary;

		public function ConstrainedBoundary(width:uint,height:uint,constrainer:Boundary) {
			sizeX = width;
			sizeY = height;
			boundry = constrainer;
		}
		public function resize(width:uint, height:uint):void {
			sizeX = width;
			sizeY = height;
		}
		public function get marginX():Number {
			return sizeX - (boundry.x2 - boundry.x1);
		}
		public function get marginY():Number {
			return sizeY - (boundry.y2 - boundry.y1);
		}

		public function get fX():Number {
			return x1 + sizeX / 2;
		}
		public function get fY():Number {
			return y1 + sizeY / 2;
		}
		public function get x1():Number {
			if (x < boundry.x1) {
				x = boundry.x1;
			} else if (boundry.x2-x < sizeX) {
				x = (boundry.x2-boundry.x1 <= sizeX ? boundry.x1 : boundry.x2-sizeX);
			}
			return x;
		}
		public function get y1():Number {
			if (y < boundry.y1) {
				y = boundry.y1;
			} else if (boundry.y2-y < sizeY) {
				y = (boundry.y2-boundry.y1 <= sizeY ? boundry.y1 : boundry.y2-sizeY);
			}
			return y;
		}
		public function get x2():Number {
			var x:Number = x1+sizeX;
			return (x > boundry.x2 ? boundry.x2 : x);
		}
		public function get y2():Number {
			var y:Number = y1+sizeY;
			return (y > boundry.y2 ? boundry.y2 : y);
		}

		public function set fX(a:Number):void {
			x = a - sizeX / 2;
		}
		public function set fY(b:Number):void {
			y = b - sizeY / 2;
		}
		public function set x1(a:Number):void {
			x = a;
		}
		public function set y1(b:Number):void {
			y = b;
		}
		public function set x2(a:Number):void {
			x = a - sizeX;
		}
		public function set y2(b:Number):void {
			y = b - sizeY;
		}

		public function move(a:Number, b:Number):void {
			x += a;
			y += b;
		}
	}
}
