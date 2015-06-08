//
//  Mission.swift
//  Galaxy
//
//  Created by Philip Deisinger on 6/6/15.
//  Copyright (c) 2015 PDice. All rights reserved.
//

import Foundation
import SpriteKit

class Mission {
    var completed = false
    var difficulty = 0
    
    var startingChunk: (Int32, Int32)!
    var goalChunk: (Int32, Int32)!
    
    init(startingChunk: (Int32, Int32), goalChunk: (Int32, Int32)) {
        self.startingChunk = startingChunk
        self.goalChunk = goalChunk
    }
}
