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
package com.brokenfunction.ezlo {
	public interface AdjustableBoundary extends Boundary {
		function get ax1():Number;
		function set ax1(x:Number):void;
		function get ay1():Number;
		function set ay1(y:Number):void;
		function get ax2():Number;
		function set ax2(x:Number):void;
		function get ay2():Number;
		function set ay2(y:Number):void;
		function adjBounds(x1:Number, y1:Number, x2:Number, y2:Number):void;
	}
}