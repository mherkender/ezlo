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
package com.brokenfunction.ezlo.display {
	import com.brokenfunction.ezlo.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class SuperBitmapData extends Sprite {
		static private const zero:Point = new Point(0, 0);

		static public function createSolidColor(width:uint, height:uint, color:uint = 0, transparent:Boolean = true):SuperBitmapData {
			safeCopy = new BitmapData(width, height, transparent, color);
			return new SuperBitmapData(safeCopy, 0, 0);
		}

		// A hack to save SuperBitmapData the trouble of cloning some BitmapDatas
		static private var safeCopy:BitmapData;

		private var bitmap:Bitmap = new Bitmap();
		private var edit:BitmapData = null;
		private var eX:int = 0;
		private var eY:int = 0;

		public function SuperBitmapData(data:Object, offsetX:int = 0, offsetY:int = 0) {
			super();

			bitmap.x = offsetX;
			bitmap.y = offsetY;
			addChild(bitmap);

			var bitmapData:BitmapData;

			if (data is Class)
				data = new data();
			if (data is BitmapData)
				bitmapData = data as BitmapData;
			if (data is Bitmap) {
				bitmapData = (data as Bitmap).bitmapData;
			}

			if (bitmapData) {
				if (data != safeCopy) {
					var copy:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, bitmapData.transparent);
					copy.copyPixels(bitmapData, bitmapData.rect, zero);
					bitmapData = copy;
				} else {
					safeCopy = null;
				}
				bitmap.bitmapData = bitmapData;
			} else {
				throw new Error("Unable to retrieve BitmapData from " + data);
			}
		}

		private function resetEdit():void {
			if (edit) {
				edit.dispose();
				edit = null;
			}
			edit = bitmap.bitmapData.clone();
			eX = int(bitmap.x);
			eY = int(bitmap.y);
		}
		public function move(x:int, y:int):void {
			if (!edit) resetEdit();
			eX += x;
			eY += y;
		}
		public function flipHorizontal():void {
			if (!edit) resetEdit();
			var old:BitmapData = edit;
			edit = new BitmapData(old.width, old.height, old.transparent, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(-1, 1);
			matrix.translate(old.width, 0);
			edit.draw(old, matrix);
		}
		public function subCrop(x:int, y:int, width:uint, height:uint, offX:int = 0, offY:int = 0):void {
			if (!edit) resetEdit();
			var old:BitmapData = edit;
			if (!width) width = old.width;
			if (!height) height = old.height;
			edit = new BitmapData(width, height, old.transparent);
			edit.copyPixels(old, new Rectangle(x, y, width, height), zero);
			eX += offX;
			eY += offY;
		}
		public function crop(width:uint, height:uint, x:int = 0, y:int = 0):void {
			subCrop(x, y, width, height, x, y);
		}
		public function paletteProcess(a:Array, b:Array):void {
			if (!edit) resetEdit();
			var p:uint, q:uint;
			while (a.length && b.length)
				edit.threshold(edit, edit.rect, zero, "==", uint(a.shift()), uint(b.shift()));
		}
		public function trimTransparency():void {
			if (!edit) resetEdit();
			var old:BitmapData = edit;
			var rect:Rectangle = old.getColorBoundsRect(0xff000000, 0x00000000, false);
			if (rect.width < 1 || rect.height < 1) return;
			edit = new BitmapData(uint(rect.width), uint(rect.height), old.transparent);
			edit.copyPixels(old, rect, zero);
			old.dispose();
			eX += int(rect.x);
			eY += int(rect.y);
		}
		public function resize(width:uint, height:uint):void {
			if (!edit) resetEdit();
			var old:BitmapData = edit;
			var x:uint = old.width, y:uint = old.height;
			edit = new BitmapData(
				(width)? width :x,
				(height)? height :y,
				old.transparent
			);
			edit.copyPixels(old, old.rect, zero);
			while (x < width) {
				edit.scroll(x, 0);
				x *= 2;
			}
			while (y < height) {
				edit.scroll(0, y);
				y *= 2;
			}
		}
		public function overlay(b:SuperBitmapData, x:int = 0, y:int = 0):void {
			// todo
		}
		public function overlayUnchanged(b:SuperBitmapData, x:int = 0, y:int = 0):void {
			// todo
		}
		public function cancelChanges():void {
			if (edit) {
				edit.dispose();
				edit = null;
			}
		}
		public function createClone():SuperBitmapData {
			if (edit) {
				safeCopy = edit.clone();
				return (new SuperBitmapData(safeCopy, eX, eY));
			}
			return createUnchangedClone();
		}
		public function createCloneAndCancelChanges():SuperBitmapData {
			if (edit && edit.width && edit.height) {
				safeCopy = edit;
				var copy:SuperBitmapData = new SuperBitmapData(safeCopy, eX, eY);
				edit = null;
				return copy;
			}
			return createUnchangedClone();
		}
		public function createUnchangedClone():SuperBitmapData {
			return new SuperBitmapData(bitmap.bitmapData, int(bitmap.x), int(bitmap.y));
		}
		public function createBitmapData():BitmapData {
			return (bitmap.bitmapData)? bitmap.bitmapData.clone() :null;
		}
	}
}
