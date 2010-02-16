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

	public class ChangePosition implements Position {
		private var _associate:Position;
		private var _x:Number;
		private var _y:Number;

		public function ChangePosition(associate:Position, x:Number, y:Number) {
			_associate = associate;
			_x = x;
			_y = y;
		}

		public function get fX():Number {return _associate.fX + _x;}
		public function get fY():Number {return _associate.fY + _y;}
		public function set fX(x:Number):void {_associate.fX = x - _x;}
		public function set fY(y:Number):void {_associate.fY = y - _y;}

		public function move(x:Number, y:Number):void {
			_associate.move(x, y);
		}
	}
}
