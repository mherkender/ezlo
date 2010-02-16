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
package com.brokenfunction.ezlo.move {
	import com.brokenfunction.ezlo.*;
	
	public class BasicMovementServiceBoundary implements Boundary {
		private var _x1:Number = 0;
		private var _y1:Number = 0;
		private var _x2:Number = 0;
		private var _y2:Number = 0;
		private var _x1_mod:Number = 0;
		private var _y1_mod:Number = 0;
		private var _x2_mod:Number = 0;
		private var _y2_mod:Number = 0;
		
		public function BasicMovementServiceBoundary() {
		}
		
		public function get fX():Number {return 0;}
		public function get fY():Number {return 0;}
		public function get x1():Number {return _x1;}
		public function get y1():Number {return _y1;}
		public function get x2():Number {return _x2;}
		public function get y2():Number {return _y2;}
		public function set fX(x:Number):void {}
		public function set fY(y:Number):void {}
		public function set x1(x:Number):void {_x1_mod = x;}
		public function set y1(y:Number):void {_y1_mod = y;}
		public function set x2(x:Number):void {_x2_mod = x;}
		public function set y2(y:Number):void {_y2_mod = y;}
		public function move(x:Number, y:Number):void {}
		
		public function set x1_real(x:Number):void {_x1 = _x1_mod = x;}
		public function set y1_real(y:Number):void {_y1 = _y1_mod = y;}
		public function set x2_real(x:Number):void {_x2 = _x2_mod = x;}
		public function set y2_real(y:Number):void {_y2 = _y2_mod = y;}
		public function get x1_modified():Number {return _x1_mod;}
		public function get y1_modified():Number {return _y1_mod;}
		public function get x2_modified():Number {return _x2_mod;}
		public function get y2_modified():Number {return _y2_mod;}
	}
}