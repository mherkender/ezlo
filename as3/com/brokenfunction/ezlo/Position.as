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
	public interface Position {
		function get fX():Number;
		function get fY():Number;
		function set fX(x:Number):void;
		function set fY(y:Number):void;
		
		function move(x:Number, y:Number):void;
	}
}