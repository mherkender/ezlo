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

	public class RectangleBoundary extends Rectangle implements AdjustableBoundary {
		public function RectangleBoundary(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			super(x, y, width, height);
		}

		public function get x1():Number {return x;}
		public function get y1():Number {return y;}
		public function get x2():Number {return right;}
		public function get y2():Number {return bottom;}
		public function get fX():Number {return 0;}
		public function get fY():Number {return 0;}

		public function set fX(a:Number):void {
			// Not changable
		}
		public function set fY(b:Number):void {
			// Not changable
		}
		public function set x1(a:Number):void {
			x = a;
		}
		public function set y1(b:Number):void {
			y = b;
		}
		public function set x2(a:Number):void {
			x = a-width;// ?
		}
		public function set y2(b:Number):void {
			y = b-height;// ?
		}
		public function move(a:Number, b:Number):void {
			x += a;
			y += b;
		}

		public function get ax1():Number {return left;}
		public function get ay1():Number {return top;}
		public function get ax2():Number {return right;}
		public function get ay2():Number {return bottom;}

		public function set ax1(x:Number):void {
			left = x;
		}
		public function set ay1(y:Number):void {
			top = y;
		}
		public function set ax2(x:Number):void {
			right = x;
		}
		public function set ay2(y:Number):void {
			bottom = y;
		}
		public function adjBounds(a:Number,b:Number,c:Number,d:Number):void {
			left = a;
			top = b;
			right = c;
			bottom = d;
		}
	}
}
