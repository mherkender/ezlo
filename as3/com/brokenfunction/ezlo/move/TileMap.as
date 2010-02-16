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
	import com.brokenfunction.ezlo.geom.SimplePosition;
	
	import flash.utils.Dictionary;

	public class TileMap implements MovementMap {
		static private const nullVal:BasicValue = new BasicValue(0);

		private var _x:Number;
		private var _y:Number;
		private var _width:uint = 0;
		private var _height:uint = 0;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		private var tiles:Array = [nullVal];
		private var map:Dictionary = new Dictionary();

		public function TileMap(x:Number, y:Number, tileWidth:uint, tileHeight:uint) {
			map[0] = nullVal;
			_x = x;
			_y = y;
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
		}
		public function get x():Number {return _x;}
		public function get y():Number {return _y;}
		public function checkMoveRight(change:Boundary, obj:Object, flags:uint = 0):uint {
			var z:uint = 0;
			var u:int = Math.floor((change.x2 - _x) / _tileWidth);
			var n:int = Math.ceil((change.x1 - _x) / _tileWidth - 1)+1;
			if (u >= n) {
				var q:int = Math.floor((change.y1 - _y) / _tileHeight);
				var p:int = Math.ceil((change.y2 - _y) / _tileHeight - 1);
				if (p < 0 || !_height) q = p = 0;
				else if (q >= _height) q = p = _height-1;
				else {
					if (q < 0) q = 0;
					if (p >= _height) p = _height-1;
				}
				
				var i:int, v:uint;
				do {
					i = p;
					do {
						if ((v = map[
							(i << 16) | ((n < 0 || !_width)? 0 :(n >= _width)? _width-1 :n)
						].intersect(flags, obj)) & 0x8) {
							change.x2 = n*_tileWidth + _x;
							z |= v;
							u = n;
						}
					} while (--i >= q);
				} while (u >= ++n);
			}
			return z;
		}
		public function checkMoveLeft(change:Boundary, obj:Object, flags:uint = 0):uint {
			var z:uint = 0;
			var u:int = Math.ceil((change.x1- _x) / _tileWidth - 1);
			var n:int = Math.floor((change.x2 - _x) / _tileWidth)-1;
			if (u <= n) {
				var q:int = Math.floor((change.y1 - _y) / _tileHeight);
				var p:int = Math.ceil((change.y2 - _y) / _tileHeight - 1);
				if (p < 0 || !_height) q = p = 0;
				else if (q >= _height) q = p = _height-1;
				else {
					if (q < 0) q = 0;
					if (p >= _height) p = _height-1;
				}
				
				var i:int, v:uint;
				do {
					i = p;
					do {
						if ((v = map[
							(i << 16) | ((n < 0 || !_width)? 0 :(n >= _width)? _width-1 :n)
						].intersect(flags, obj)) & 0x2) {
							change.x1 = (n+1)*_tileWidth + _x;
							z |= v;
							u = n;
						}
					} while (--i >= q);
				} while (u <= --n);
			}
			return z;
		}
		public function checkMoveDown(change:Boundary, obj:Object, flags:uint = 0):uint {
			var z:uint = 0;
			var u:int = Math.floor((change.y2 - _y) / _tileHeight);
			var n:int = Math.ceil(((change.y1 - _y) / _tileHeight) - 1)+1;
			if (u >= n) {
				var q:int = Math.floor((change.x1 - _x) / _tileWidth);
				var p:int = Math.ceil((change.x2 - _x) / _tileWidth - 1);
				if (p < 0 || !_width) q = p = 0;
				else if (q >= _width) q = p = _width-1;
				else {
					if (q < 0) q = 0;
					if (p >= _width) p = _width-1;
				}
				
				var i:int, v:uint;
				do {
					i = p;
					do {
						if ((v = map[
							(((n < 0 || !_height)? 0 :(n >= _height)? _height-1 :n) << 16) | i
						].intersect(flags, obj)) & 0x1) {
							change.y2 = n*_tileHeight + _y;
							z |= v;
							u = n;
						}
					} while (--i >= q);
				} while (u >= ++n);
			}
			return z;
		}
		public function checkMoveUp(change:Boundary, obj:Object, flags:uint = 0):uint {
			var z:uint = 0;
			var u:int = Math.ceil((change.y1 - _y) / _tileHeight - 1);
			var n:int = Math.floor((change.y2 - _y) / _tileHeight)-1;
			if (u <= n) {
				var q:int = Math.floor((change.x1 - _x) / _tileWidth);
				var p:int = Math.ceil((change.x2 - _x) / _tileWidth - 1);
				if (p < 0 || !_width) q = p = 0;
				else if (q >= _width) q = p = _width-1;
				else {
					if (q < 0) q = 0;
					if (p >= _width) p = _width-1;
				}
				
				var i:int, v:uint;
				do {
					i = p;
					do {
						if ((v = map[
							(((n < 0 || !_height)? 0 :(n >= _height)? _height-1 :n) << 16) | i
						].intersect(flags, obj)) & 0x4) {
							change.y1 = (n+1)*_tileHeight + _y;
							z |= v;
							u = n;
						}
					} while (--i >= q);
				} while (u <= --n);
			}
			return z;
		}
		public function checkPoint(pos:Position, obj:Object, flags:uint = 0):uint {
			var a:int = Math.floor((pos.fX - _x) / _tileWidth), b:int = Math.floor((pos.fY - _y) / _tileHeight);
			var v:MovementValue = map[
				(((b < 0 || !_height)? 0 :(b >= _height)? _height-1 :b) << 16) |
				((a < 0 || !_width)? 0 :(a >= _width)? _width-1 :a)
			]
			flags &= v.value;
			if ((flags & 0x0400) == 0x0400) {
				// snap horizontally, for this is a ladder
				pos.fX = ((a + 0.5) * _tileWidth) + _x;
			}
			if ((flags & ~0x0400) !== 0) v.hover(flags, obj);
			return flags;
		}
		public function pushRow(a:Array):void {
			if (_height > 0xffff) throw new Error("Maximum _height reached");
			var i:uint = a.length, h:uint = (_height << 16);
			if (i > 0xffff) throw new Error("Maximum _width reached");
			if (i > _width) _width = i;
			while (i > 0) {
				i--;
				map[h | i] = tiles[a[i]] || nullVal;
			}
			_height++;
		}
		public function pushStrRow(str:String):void {
			var col:uint = str.length;
			var row:uint = (_height << 16);
			
			if (_height > 0xffff) throw new Error("Maximum _height reached");
			if (col > 0xffff) throw new Error("Maximum _width reached");
			
			if (col > _width) _width = col;
			while (col-- > 0) {
				map[row | col] = tiles[parseInt(str.charAt(col), 36)] || nullVal;
			}
			_height++;
		}
		public function pushTile(t:MovementValue):void {
			tiles.push(t);
		}
		public function getTile(x:uint, y:uint):MovementValue {
			return map[
				(((!_height)? 0 :(y >= _height)? _height-1 :y) << 16) |
				 ((!_width)? 0 :(x >= _width)? _width-1 :x)
			];
		}
		public function getTilePosition(x:Number, y:Number):Position {
			return new SimplePosition(
				int((x - _x) / _tileWidth),
				int((y - _y) / _tileHeight));
		}
		public function getTilePositionX(x:Number):int {
			return (x - _x) / _tileWidth;
		}
		public function getTilePositionY(y:Number):int {
			return (y - _y) / _tileHeight;
		}
		public function getRealPositionX(x:int):Number {
			return (x * _tileWidth) + _x;
		}
		public function getRealPositionY(y:int):Number {
			return (y * _tileHeight) + _y;
		}
	}
}
