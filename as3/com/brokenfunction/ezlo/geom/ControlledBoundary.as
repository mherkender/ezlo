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
	
	public class ControlledBoundary implements Boundary {
		private var _fX:Number;
		private var _fY:Number;
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;
		
		public function ControlledBoundary(fX:Number = 0, fY:Number = 0, x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0) {
			_fX = fX;
			_fY = fY;
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
		}
		
		public function get fX():Number {return _fX;}
		public function get fY():Number {return _fY;}
		public function get x1():Number {return _x1;}
		public function get y1():Number {return _y1;}
		public function get x2():Number {return _x2;}
		public function get y2():Number {return _y2;}
		public function set fX(x:Number):void {}
		public function set fY(y:Number):void {}
		public function set x1(x:Number):void {}
		public function set y1(y:Number):void {}
		public function set x2(x:Number):void {}
		public function set y2(y:Number):void {}
		public function move(x:Number, y:Number):void {}
		
		public function set fX_real(x:Number):void {_fX = x;}
		public function set fY_real(y:Number):void {_fY = y;}
		public function set x1_real(x:Number):void {_x1 = x;}
		public function set y1_real(y:Number):void {_y1 = y;}
		public function set x2_real(x:Number):void {_x2 = x;}
		public function set y2_real(y:Number):void {_y2 = y;}
		
		public function copy(original:Boundary):void {
			_fX = original.fX;
			_fY = original.fY;
			_x1 = original.x1;
			_y1 = original.y1;
			_x2 = original.x2;
			_y2 = original.y2;
		}
	}
}