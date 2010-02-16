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

	// DummyBoundary is a poor name, it was meant to be more like DumbBoundary
	public class DummyBoundary implements AdjustableBoundary {
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;

		public function DummyBoundary(x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0) {
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
		}
		public function copyBounds(bounds:Boundary):void {
			_x1 = bounds.x1;
			_y1 = bounds.y1;
			_x2 = bounds.x2;
			_y2 = bounds.y2;
		}

		public function get fX():Number {
			return 0;
		}
		public function get fY():Number {
			return 0;
		}
		public function get x1():Number {
			return _x1;
		}
		public function get y1():Number {
			return _y1;
		}
		public function get x2():Number {
			return _x2;
		}
		public function get y2():Number {
			return _y2;
		}

		public function set fX(x:Number):void {
			_x1 += x;
			_x2 += x;
		}
		public function set fY(y:Number):void {
			_y1 += y;
			_y2 += y;
		}
		public function set x1(x:Number):void {
			_x1 = x;
		}
		public function set y1(y:Number):void {
			_y1 = y;
		}
		public function set x2(x:Number):void {
			_x2 = x;
		}
		public function set y2(y:Number):void {
			_y2 = y;
		}

		public function move(x:Number, y:Number):void {
			_x1 += x;
			_x2 += x;
			_y1 += y;
			_y2 += y;
		}

		public function get ax1():Number {
			return _x1;
		}
		public function set ax1(x:Number):void {
			_x1 = x;
		}
		public function get ay1():Number {
			return _y1;
		}
		public function set ay1(y:Number):void {
			_y1 = y;
		}
		public function get ax2():Number {
			return _x2;
		}
		public function set ax2(x:Number):void {
			_x2 = x;
		}
		public function get ay2():Number {
			return _y2;
		}
		public function set ay2(y:Number):void {
			_y2 = y;
		}
		public function adjBounds(a:Number,b:Number,c:Number,d:Number):void {
			_x1 = a;
			_y1 = b;
			_x2 = c;
			_y2 = d;
		}
	}
}
