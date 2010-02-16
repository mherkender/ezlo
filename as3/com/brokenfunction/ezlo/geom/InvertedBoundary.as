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

	public class InvertedBoundary implements Boundary {
		private var parentBounds:Boundary;
		private var _invertX:Boolean;
		private var _invertY:Boolean;

		public function InvertedBoundary(bounds:Boundary, invertX:Boolean = true, invertY:Boolean = true) {
			parentBounds = bounds;
			_invertX = invertX;
			_invertY = invertY;
		}

		public function get fX():Number {
			return parentBounds.fX;
		}
		public function get fY():Number {
			return parentBounds.fY;
		}
		public function get x1():Number {
			return (_invertX ? parentBounds.x2 : parentBounds.x1);
		}
		public function get y1():Number {
			return (_invertY ? parentBounds.y2 : parentBounds.y1);
		}
		public function get x2():Number {
			return (_invertX ? parentBounds.x1 : parentBounds.x2);
		}
		public function get y2():Number {
			return (_invertY ? parentBounds.y1 : parentBounds.y2);
		}

		public function set fX(x:Number):void {
			parentBounds.fX = x;
		}
		public function set fY(y:Number):void {
			parentBounds.fY = y;
		}
		public function set x1(x:Number):void {
			if (_invertX) parentBounds.x2 = x;
			else parentBounds.x1 = x;
		}
		public function set y1(y:Number):void {
			if (_invertY) parentBounds.y2 = y;
			else parentBounds.y1 = y;
		}
		public function set x2(x:Number):void {
			if (_invertX) parentBounds.x1 = x;
			else parentBounds.x2 = x;
		}
		public function set y2(y:Number):void {
			if (_invertY) parentBounds.y1 = y;
			else parentBounds.y2 = y;
		}

		public function move(x:Number, y:Number):void {
			parentBounds.move(x, y);
		}
	}
}
