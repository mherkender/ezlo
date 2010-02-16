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
	public interface MovementMap {
		function checkMoveUp(change:Boundary, obj:Object, flags:uint = 0):uint;
		function checkMoveRight(change:Boundary, obj:Object, flags:uint = 0):uint;
		function checkMoveDown(change:Boundary, obj:Object, flags:uint = 0):uint;
		function checkMoveLeft(change:Boundary, obj:Object, flags:uint = 0):uint;
		function checkPoint(position:Position, obj:Object, flags:uint = 0):uint;
	}
	/*
		MovementMap input/return bits:
		0: Block movement (bottom of boundry)
		1: Block movement (left of boundry)
		2: Block movement (top of boundry)
		3; Block movement (right of boundry)
		4: Attach (bottom of boundry)
		5: Attach (left of boundry)
		6: Attach (top of boundry)
		7: Attach (right of boundry)
		8-11: Game-specific hover activators
		12-15: Game-specific touch activators
		16-31: Reserved
		
		MovementValue bits:
		0: Block movement (from above)
		1: Block movement (from right)
		2: Block movement (from below)
		3: Block movement (from left)
		4: Angled tile indicator
		5: Angled tile is reversed
		6: Reserved
		7: Reserved
		8-11: Game-specific hover activators
		12-15: Game-specific touch activators
		16-31: Reserved
		
		mmvs3 custom events
		8 and 12 - General trigger
		9 and 13 - Hero (user-controlled) trigger
		14 - Ryu-grabbable (pass-through and wall-climb)
		10 - Climbable
	*/
}