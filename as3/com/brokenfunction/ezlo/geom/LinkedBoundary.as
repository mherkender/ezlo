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

	public class LinkedBoundary implements Boundary {
		private var _link:Position;
		private var ax:Number;
		private var ay:Number;
		private var bx:Number;
		private var by:Number;

		public function LinkedBoundary(link:Position, x1:Number, y1:Number, x2:Number, y2:Number) {
			_link = link;
			ax = x1;
			ay = y1;
			bx = x2;
			by = y2;
		}

		public function get fX():Number {
			return _link.fX;
		}
		public function get fY():Number {
			return _link.fY;
		}
		public function get x1():Number {
			return _link.fX+ax;
		}
		public function get y1():Number {
			return _link.fY+ay;
		}
		public function get x2():Number {
			return _link.fX+bx;
		}
		public function get y2():Number {
			return _link.fY+by;
		}

		public function set fX(x:Number):void {
			_link.fX = x;
		}
		public function set fY(y:Number):void {
			_link.fY = y;
		}
		public function set x1(x:Number):void {
			_link.fX = x-ax;
		}
		public function set y1(y:Number):void {
			_link.fY = y-ay;
		}
		public function set x2(x:Number):void {
			_link.fX = x-bx;
		}
		public function set y2(y:Number):void {
			_link.fY = y-by;
		}

		public function move(x:Number, y:Number):void {
			_link.move(x, y);
		}
	}
}
