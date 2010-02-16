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
package com.brokenfunction.ezlo.scroll {
	import com.brokenfunction.ezlo.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import com.brokenfunction.ezlo.geom.ConstrainedBoundary;
	import com.brokenfunction.ezlo.geom.DummyBoundary;
	import com.brokenfunction.ezlo.geom.StalledBoundary;

	public class MaskedScroller extends SimpleScrollService implements ScrollService {
		static public const AUTOSCALE:Number = 0;

		private var bmask:Bitmap = new Bitmap(new BitmapData(256, 256, false));
		private var screenWidth:uint;
		private var screenHeight:uint;
		private var originalWidth:uint;
		private var originalHeight:uint;
		private var finalWidth:Number = 0;
		private var finalHeight:Number = 0;
		private var transformScale:Number;
		private var _scrollBounds:DummyBoundary;
		private var stalledBounds:StalledBoundary;
		private var constrainedBounds:ConstrainedBoundary;

		public function MaskedScroller(width:uint, height:uint, scale:Number, stall:uint = 0) {
			super();
			if (width*height <= 0) throw new Error("Screen size is invalid");
			originalWidth = screenWidth = width;
			originalHeight = screenHeight = height;
			addChild(mask = bmask);
			_scrollBounds = new DummyBoundary(
				Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY,
				Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY
			);
			constrainedBounds = new ConstrainedBoundary(0, 0, _scrollBounds);
			if (stall) stalledBounds = new StalledBoundary(-stall, -stall, stall, stall, constrainedBounds);
			setScale(scale);
		}
		public function destroy():void {
			// todo
		}

		public override function get scrollBounds():AdjustableBoundary {
			return _scrollBounds;
		}
		public override function get visibleBounds():Boundary {
			return stalledBounds || constrainedBounds;
		}

		public function setScale(scale:Number):void {
			if (!isFinite(scale)) throw new Error("Number isn't finite");
			transformScale = scale;
			update();
		}
		public function resize(width:uint, height:uint):void {
			screenWidth = width;
			screenHeight = height;
			update();
		}
		private function update():void {
			var scale:Number = (transformScale === AUTOSCALE)?
				Math.floor(Math.min(screenWidth/originalWidth, screenHeight/originalHeight)) :
				transformScale;
			if (scale <= 0)
				scale = 1;

			transform.matrix = new Matrix(scale, 0, 0, scale, 0, 0);
			constrainedBounds.resize(
				screenWidth / transform.matrix.a,
				screenHeight / transform.matrix.d);
			finalWidth = finalHeight = 0;
			render();
		}

		public function render():void {
			var a:Number = -constrainedBounds.x1
			var b:Number = -constrainedBounds.y1;
			forEachLayer(function (layer:DisplayObjectContainer, index:uint):void {
				layer.x = a;
				layer.y = b;
			});

			a = constrainedBounds.x2 + a;
			b = constrainedBounds.y2 + b;
			if (finalWidth !== a || finalHeight !== b) {
				var dot:Number = a * b;
				if (isFinite(dot) && dot > 0) {
					bmask.width = finalWidth = a;
					bmask.height = finalHeight = b;
					x = ((a = a * transform.matrix.a - screenWidth) < 0)? a / -2 : 0;
					y = ((b = b * transform.matrix.d - screenHeight) < 0)? b / -2 : 0;
				}
			}
		}
	}
}
