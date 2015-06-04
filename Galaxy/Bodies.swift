//
//  Bodies.swift
//  Galaxy
//
//  Created by Philip Deisinger on 6/1/15.
//  Copyright (c) 2015 PDice. All rights reserved.
//

import Foundation
import SpriteKit

class Star: SKSpriteNode {
    var worldX: CGFloat!
    var worldY: CGFloat!
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
//    init(color: UIColor!, size: CGSize, worldX: CGFloat!, worldY: CGFloat!) {
//        self.worldX = worldX
//        self.worldY = worldY
//        self.color = color
//        self.size = size
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Planet: SKSpriteNode {
    var worldX: CGFloat!
    var worldY: CGFloat!
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Planet2 : SKShapeNode {
    var worldX: CGFloat!
    var worldY: CGFloat!
    
    
    init(circleOfRadius: CGFloat) {
        super.init()
        var path2 = CGPathCreateMutable()
        CGPathMoveToPoint(path2, nil, 10, 10)
        CGPathAddLineToPoint(path2, nil, 20, 10)
        CGPathAddArc(path2, nil, 100, 100, circleOfRadius, CGFloat(-M_PI_2), CGFloat(M_PI_2 * 3), false)
        CGPathCloseSubpath(path2)
        path = path2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
