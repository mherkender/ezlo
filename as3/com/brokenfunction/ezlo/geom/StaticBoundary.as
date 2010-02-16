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

	public class StaticBoundary implements Boundary {
		public static function createDuplicate(b:Boundary):StaticBoundary {
			return new StaticBoundary(b.fX, b.fY, b.x1, b.y1, b.x2, b.y2);
		}

		private var _fX:Number;
		private var _fY:Number;
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;

		public function StaticBoundary(fX:Number, fY:Number, x1:Number, y1:Number, x2:Number, y2:Number) {
			_fX = fX;
			_fY = fY;
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
		}

		public final function get fX():Number {return _fX;}
		public final function get fY():Number {return _fY;}
		public final function get x1():Number {return _x1;}
		public final function get y1():Number {return _y1;}
		public final function get x2():Number {return _x2;}
		public final function get y2():Number {return _y2;}
		public final function set fX(x:Number):void {}
		public final function set fY(y:Number):void {}
		public final function set x1(x:Number):void {}
		public final function set y1(y:Number):void {}
		public final function set x2(x:Number):void {}
		public final function set y2(y:Number):void {}
		public final function move(x:Number, y:Number):void {}
	}
}
