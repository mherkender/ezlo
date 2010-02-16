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
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	public class SimpleBoundary implements AdjustableBoundary {
		private var _fX:Number;
		private var _fY:Number;
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;
		private var ax:Number;
		private var ay:Number;
		private var bx:Number;
		private var by:Number;

		public function SimpleBoundary(fX:Number = 0, fY:Number = 0, x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0) {
			_fX = fX;
			_fY = fY;
			_x1 = _fX+(ax = x1);
			_y1 = _fY+(ay = y1);
			_x2 = _fX+(bx = x2);
			_y2 = _fY+(by = y2);
		}

		public function get fX():Number {return _fX;}
		public function get fY():Number {return _fY;}
		public function get x1():Number {return _x1;}
		public function get y1():Number {return _y1;}
		public function get x2():Number {return _x2;}
		public function get y2():Number {return _y2;}

		public function set fX(x:Number):void {
			_x1 = (_fX = x)+ax;
			_x2 = _fX+bx;
		}
		public function set fY(y:Number):void {
			_y1 = (_fY = y)+ay;
			_y2 = _fY+by;
		}
		public function set x1(x:Number):void {
			_x2 = (_fX = (_x1 = x)-ax)+bx;
		}
		public function set y1(y:Number):void {
			_y2 = (_fY = (_y1 = y)-ay)+by;
		}
		public function set x2(x:Number):void {
			_x1 = (_fX = (_x2 = x)-bx)+ax;
		}
		public function set y2(y:Number):void {
			_y1 = (_fY = (_y2 = y)-by)+ay;
		}
		public function move(x:Number, y:Number):void {
			_x1 = (_fX += x)+ax;
			_x2 = _fX+bx;
			_y1 = (_fY += y)+ay;
			_y2 = _fY+by;
		}

		public function get ax1():Number {return ax;}
		public function get ay1():Number {return ay;}
		public function get ax2():Number {return bx;}
		public function get ay2():Number {return by;}

		public function set ax1(x:Number):void {
			_x1 = _fX+(ax = x);
		}
		public function set ay1(y:Number):void {
			_y1 = _fY+(ay = y);
		}
		public function set ax2(x:Number):void {
			_x2 = _fX+(bx = x);
		}
		public function set ay2(y:Number):void {
			_y2 = _fY+(by = y);
		}
		public function adjBounds(a:Number,b:Number,c:Number,d:Number):void {
			_x1 = _fX+(ax = a);
			_y1 = _fY+(ay = b);
			_x2 = _fX+(bx = c);
			_y2 = _fY+(by = d);
		}
	}
}
