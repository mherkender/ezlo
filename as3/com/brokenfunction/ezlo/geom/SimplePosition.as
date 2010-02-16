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
	import flash.geom.Point;

	public class SimplePosition extends Point implements Position {
		public function SimplePosition(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		public function get fX():Number {return x;}
		public function get fY():Number {return y;}
		public function set fX(a:Number):void {x = a;}
		public function set fY(b:Number):void {y = b;}
		public function move(a:Number, b:Number):void {
			x += a;
			y += b;
		}
	}
}
