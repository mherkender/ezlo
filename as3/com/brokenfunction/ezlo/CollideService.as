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
	public interface CollideService {
		function checkGroup(group:String, against:Boundary, require:uint, callback:Function):void;

		function groupBoundary(group:String, obj:Object, boundary:Boundary):void;
		function ungroupBoundary(group:String, obj:Object):void;
		function watchBoundary(boundary:Boundary, callback:Function/*<uint>*/, x1:Number, y1:Number, x2:Number, y2:Number, require:uint = 0):uint;
		function unwatchBoundary(boundary:Boundary, callback:Function/*<uint>*/):void;
	}
}
