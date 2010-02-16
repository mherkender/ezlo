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
	
	public class DifferenceBoundary implements Boundary {
		private var boundry1:Boundary;
		private var boundry2:Boundary;
		
		public function DifferenceBoundary(a:Boundary, b:Boundary) {
			boundry1 = a;
			boundry2 = b;
		}
		
		public function get fX():Number {return boundry1.fX - boundry2.fX;}
		public function get fY():Number {return boundry1.fY - boundry2.fY;}
		public function get x1():Number {return boundry1.x1 - boundry2.x1;}
		public function get y1():Number {return boundry1.y1 - boundry2.y1;}
		public function get x2():Number {return boundry1.x2 - boundry2.x2;}
		public function get y2():Number {return boundry1.y2 - boundry2.y2;}
		public function set fX(x:Number):void {}
		public function set fY(y:Number):void {}
		public function set x1(x:Number):void {}
		public function set y1(y:Number):void {}
		public function set x2(x:Number):void {}
		public function set y2(y:Number):void {}
		public function move(x:Number, y:Number):void {}
	}
}