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
	import com.brokenfunction.ezlo.geom.DummyBoundary;
	
	public class BasicMovementService implements MovementService {
		static private const nullMap:NullMap = new NullMap();
		private var pushX:Number;
		private var first:Entry = null;
		private var cached1:BasicMovementServiceBoundary;
		private var cached3:DummyBoundary;
		
		public function BasicMovementService(shiftMoveX:Number = 0) {
			pushX = shiftMoveX;
		}
		public function addMap(map:MovementMap, change:Boundary = null):void {
			trace("adding map ("+map+")");
			first = new Entry(first);
			first.map = map;
			first.change = change;
		}
		public function removeMap(map:MovementMap):void {
			var eA:Entry = first, eB:Entry;
			trace("removing map ("+map+")");
			if (eA) {
				if (eA.map === map) {
					eA.map = nullMap;
					first = eA.next;
					return;
				}
				while (eB = eA.next) {
					if (eB.map === map) {
						eB.map = nullMap;
						eA.next = eB.next;
						return;
					}
					if ((eA = eB.next)) {
						if (eA.map === map) {
							eA.map = nullMap;
							eB.next = eA.next;
							return;
						}
					} else break;
				}
			}
		}
		public function checkMovement(before:Boundary, after:Boundary, obj:Object, flags:uint = 0):uint {
			var change:BasicMovementServiceBoundary = cached1;
			if (!change) change = new BasicMovementServiceBoundary();
			cached1 = null;
			
			var result:uint = 0, tmp:uint;
			var entry:Entry;
			
			var x:Number = 0;
			if (pushX && (before.x2 - before.x1) >= pushX * 2) {
				x = pushX;
			}
			
			// HORIZONTAL
			if (flags & 0xa && (entry = first)) {
				do {
					change.y1_real = ((flags & 0x4 || after.y1 > before.y1) ? before.y1 : after.y1);
					change.y2_real = ((flags & 0x1 || after.y2 < before.y2) ? before.y2 : after.y2);
					if (entry.change) {
						tmp = 0;
						
						if (flags & 0x8) {// rightward movement (dynamic)
							if (entry.change.x1 < 0) {
								change.x1_real = before.x2 + entry.change.x1 - x;
								change.x2_real = after.x2;
							} else {
								change.x1_real = before.x2 - x;
								change.x2_real = after.x2 + entry.change.x1;
							}
							result |= (tmp = entry.map.checkMoveRight(change, obj, flags & 0xf008) & 0xf008);
							if (tmp & 0x8) after.x2 = change.x2_modified;
						}
						if (flags & 0x2) {// leftward movement (dynamic)
							if (entry.change.x2 < 0) {
								change.x1_real = after.x1;
								change.x2_real = before.x1 + entry.change.x2 + x;
							} else {
								change.x1_real = after.x1 + entry.change.x2;
								change.x2_real = before.x1 + x;
							}
							result |= (tmp |= entry.map.checkMoveLeft(change, obj, flags & 0xf002) & 0xf002);
							if (tmp & 0x2) after.x1 = change.x1_modified;
						}
						
						// shift vertically when attached
						if (flags & 0xa0 && tmp & 0xa) {
							result |= (tmp << 1) & 0xa0;
							after.fY += entry.change.fY;
						}
					} else {
						if (flags & 0x8) {// rightward movement
							change.x1_real = before.x2 - x;
							change.x2_real = after.x2;
							result |= entry.map.checkMoveRight(change, obj, flags & 0xf008) & 0xf008;
							after.x2 = change.x2_modified;
						}
						if (flags & 0x2) {// leftward movement
							change.x1_real = after.x1;
							change.x2_real = before.x1 + x;
							result |= entry.map.checkMoveLeft(change, obj, flags & 0xf002) & 0xf002;
							after.x1 = change.x1_modified;
						}
					}
				} while (entry = entry.next);
			}
			
			// VERTICAL
			if (flags & 0x5 && (entry = first)) {
				do {
					change.x1_real = (after.x1 > before.x1 ? before.x1 : after.x1) + x;
					change.x2_real = (after.x2 < before.x2 ? before.x2 : after.x2) - x;
					if (entry.change) {
						tmp = 0;
						
						if (flags & 0x1) {// downward movement (dynamic)
							if (entry.change.y1 < 0) {
								change.y1_real = before.y2 + entry.change.y1;
								change.y2_real = after.y2;
							} else {
								change.y1_real = before.y2;
								change.y2_real = after.y2 + entry.change.y1;
							}
							result |= (tmp = entry.map.checkMoveDown(change, obj, flags & 0xf001) & 0xf001);
							if (tmp & 0x1) after.y2 = change.y2_modified;
						}
						if (flags & 0x4) {// upward movement (dynamic)
							if (entry.change.y2 < 0) {
								change.y1_real = after.y1;
								change.y2_real = before.y1 + entry.change.y2;
							} else {
								change.y1_real = after.y1 + entry.change.y2;
								change.y2_real = before.y1;
							}
							result |= (tmp |= entry.map.checkMoveUp(change, obj, flags & 0xf004) & 0xf004);
							if (tmp & 0x4) after.y1 = change.y1_modified;
						}
						
						// shift horizontally when attached
						if (flags & 0x50 && tmp & 0x5) {
							result |= (tmp << 1) & 0x50;
							after.fX += entry.change.fX;
						}
					} else {
						if (flags & 0x1) {// downward movement
							change.y1_real = before.y2;
							change.y2_real = after.y2;
							result |= entry.map.checkMoveDown(change, obj, flags & 0xf001) & 0xf001;
							after.y2 = change.y2_modified;
						}
						if (flags & 0x4) {// upward movement
							change.y1_real = after.y1;
							change.y2_real = before.y1;
							result |= entry.map.checkMoveUp(change, obj, flags & 0xf004) & 0xf004;
							after.y1 = change.y1_modified;
						}
					}
				} while (entry = entry.next);
			}
			
			if ((flags & 0x0f00) !== 0) {
				result |= checkPoint(after, obj, flags & 0x0f00) & 0x0f00;
			}
			
			cached1 = change;
			return result;
		}
		public function triggerMovement(bounds:Boundary, obj:Object, x:Number = 0, y:Number = 0, flags:uint = 0):uint {
			var before:DummyBoundary = cached3;
			if (!before) before = new DummyBoundary();
			cached3 = null;
			
			before.copyBounds(bounds);
			bounds.move(x, y);
			var result:uint = checkMovement(before, bounds, obj, flags);
			
			cached3 = before;
			return result;
		}
		public function checkPoint(pos:Position, obj:Object, flags:uint = 0):uint {
			var result:uint = 0;
			var entry:Entry = first;
			if (entry) {
				do {
					result |= entry.map.checkPoint(pos, obj, flags);
				} while (entry = entry.next);
			}
			return result;
		}
	}
}

import com.brokenfunction.ezlo.Boundary;
import com.brokenfunction.ezlo.MovementMap;

class Entry {
	public var next:Entry;
	public var map:MovementMap;
	public var change:Boundary;
	
	public function Entry(n:Entry) {
		next = n;
	}
}