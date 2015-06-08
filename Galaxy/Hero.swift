//
//  Hero.swift
//  Galaxy
//
//  Created by Philip Deisinger on 6/1/15.
//  Copyright (c) 2015 PDice. All rights reserved.
//

import Foundation
import SpriteKit

class Hero: SKSpriteNode {
    var chunk: (Int32, Int32)
    var chunkXOffset: UInt32!
    var chunkYOffset: UInt32!
    var xVel = 0
    var yVel = 0
    var angle = CGFloat(M_PI)
    var velocity = CGFloat(0)
    var worldX = CGFloat(1)
    var worldY = CGFloat(1)
    
    var playerID = Int64(0)
    
    var maxSpeed = CGFloat(10)
    var cruisingSpeed = CGFloat(0.5)
    var resistance = CGFloat(0.1)
    
    var currentMissions = NSMutableArray()
    var completedMissions = NSMutableArray()
    
    var deltas = NSMutableDictionary()
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        chunk = (0,0)
        playerID = 1234
        super.init(texture: texture, color: color, size: size)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func increaseMaxSpeed(speed: CGFloat)       { maxSpeed += speed }
    func increaseCruisingSpeed(speed: CGFloat)  { cruisingSpeed += speed }
    func increaseResistance(speed: CGFloat)     { resistance += speed }
}

