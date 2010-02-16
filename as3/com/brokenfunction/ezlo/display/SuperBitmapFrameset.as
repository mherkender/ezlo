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
	import flash.geom.Transform;

	public class SuperBitmapFrameset extends Frameset {
		static private const defaultData:SuperBitmapData = new SuperBitmapData(new BitmapData(1, 1, true, 0x00000000));

		private var currDisp:DisplayObject;
		private var currentFrame:uint = 0;
		private var group:Object = {};

		public function SuperBitmapFrameset() {
			super();
		}
		public function addFrame(row:uint, data:SuperBitmapData):void {
			var list:Array = group[row];
			if (list) list.push(data.createClone());
			else group[row] = [data.createClone()];
		}
		public override function drawFrame(row:uint, frame:uint = 0):void {
			var list:Array = group[row];
			if (list) {
				if (frame >= list.length)
					frame = list.length - 1;
				var newDisp:DisplayObject = list[frame] as DisplayObject;
				currentFrame = frame;
				if (currDisp) {
					if (newDisp === currDisp) return;
					removeChild(currDisp);
				}
				addChild(currDisp = newDisp);
			}
		}
		public override function changeRow(row:uint):void {
			drawFrame(row, currentFrame);
		}
		public function autoFrame(
			data:SuperBitmapData, row:uint,
			startX:uint, startY:uint,
			tileWidth:uint, tileHeight:uint,
			offX:int = 0, offY:int = 0,
			repeat:uint = 1,
			changeX:int = 0, changeY:int = 0,
			flipHorizontal:Boolean = false
		):void {
			data.cancelChanges();
			var i:uint = 0;
			while (i < repeat) {
				data.subCrop(
					startX+(changeX*i), startY+(changeY*i),
					tileWidth, tileHeight,
					0, 0
				);
				if (flipHorizontal) data.flipHorizontal();
				data.move(offX, offY);
				data.trimTransparency();
				addFrame(row, data.createCloneAndCancelChanges());
				i++;
			}
		}
		public function autoRowMajorGrid(data:SuperBitmapData, columns:uint = 0, rows:uint = 0, offX:Number = 0, offY:Number = 0):void {
			if (columns <= 0) columns = 1;
			if (rows <= 0) rows = 1;
			data.cancelChanges();

			var tileWidth:uint = data.width / columns;
			var tileHeight:uint = data.height / rows;
			var i:uint = rows;
			while (i-- > 0) {
				autoFrame(
					data, i, 0, 0,
					tileWidth, tileHeight,
					offX * tileWidth, offY * tileHeight,
					columns, tileWidth, 0);
			}

		}
		public function concatTo(frameset:SuperBitmapFrameset, toRow:uint = 0, fromRow:uint = 0):void {
			var list:Array = group[fromRow];
			if (list) {
				var i:uint = 0;
				while (i < list.length) {
					frameset.addFrame(toRow, list[i] as SuperBitmapData);
					i++;
				}
			}
		}
	}
}
