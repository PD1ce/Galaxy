//
//  GameScene.swift
//  Galaxy
//
//  Created by Philip Deisinger on 6/1/15.
//  Copyright (c) 2015 PDice. All rights reserved.
//

import SpriteKit
import Foundation

class GalaxyScene: SKScene {
    
    var stars = NSMutableArray()
    var hero: Hero!
    
    var beginTouchPos: CGPoint!
    var endTouchPos: CGPoint!
    var beginTouchTime: NSTimeInterval!
    var endTouchTime: NSTimeInterval!
    
    let rotateRight = SKAction.rotateToAngle(3.1415926 / 2, duration: 0.25)
    let rotateLeft = SKAction.rotateToAngle(-3.1415926 / 2, duration: 0.25)
    
    var updateTime = 60
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        
        backgroundColor = UIColor.blackColor()
        hero.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        println("\(hero.position)")
        addChild(hero)
        //generateStars(100000)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if touches.count > 1 {
            return
        } else {
            let touch = touches.first as! UITouch
            beginTouchPos = touch.locationInNode(self)
            beginTouchTime = touch.timestamp
            println("====================================")
            println("Touch: \(beginTouchPos)")
            println("Touch Time: \(beginTouchTime)")
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
      /*
        for touch in (touches as! Set<UITouch>) {
            let prevLocation = touch.previousLocationInNode(self)
            let location = touch.locationInNode(self)
            if (location.x < prevLocation.x) {
                println("Swiping Left")
                hero.runAction(rotateLeft)
            } else if (location.x > prevLocation.x) {
                println("Swiping Right")
                hero.runAction(rotateRight)

            }
        }
        */
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count > 1 {
            return
        } else {
            let touch = touches.first as! UITouch
            endTouchPos = touch.locationInNode(self)
            endTouchTime = touch.timestamp
            println("Touch: \(endTouchPos)")
            println("Touch Vector X: \(endTouchPos.x - beginTouchPos.x)")
            println("Touch Vector Y: \(endTouchPos.y - beginTouchPos.y)")
            println("Touch Time: \(endTouchTime)")
            println("Full Touch Duration: \(endTouchTime - beginTouchTime)")
            //println("====================================")
        }
        let xVec = beginTouchPos.x - endTouchPos.x
        let yVec = beginTouchPos.y - endTouchPos.y
        var angle = atan2(yVec, xVec) + CGFloat(M_PI / 2)
        //ata
        let rotate = SKAction.rotateToAngle(angle, duration: 0.5)
        hero.runAction(rotate)
        hero.angle = CGFloat(angle)
        hero.velocity = 5 - CGFloat(endTouchTime - beginTouchTime)

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        srand(0)
        for child in children {
            child.removeFromParent()
        }
        
        stars.removeAllObjects()
        stars = getStarsForPosition(hero.worldX, worldY: hero.worldY)
        
        for star in stars {
            deriveScreenPosition(star as! Star)
            addChild(star as! SKSpriteNode)
        }
        
        addChild(hero)
        
        adjustHeroPosition()
        
        if hero.velocity <= 0.02 {
            hero.velocity = 0.02
        } else {
            hero.velocity -= 0.02
        }
       
        
        
        updateTime--
        if updateTime == 0 {
            println("\(hero.velocity)")
            updateTime = 60
        }
        
        //Create an array of all the stars in all the adjacent chunks
    }
    
    func generateStars(number: Int) -> NSMutableArray {
        let newStarArray = NSMutableArray()
        //let width = UInt32(view!.frame.width)
        //let height = UInt32(view!.frame.height)
        for var i = 0; i < number; i++ {
            let xPos = 1000 - CGFloat(rand() % 2000)
            let yPos = 1000 - CGFloat(rand() % 2000)
            //println("x:\(xPos), y: \(yPos)")
            let star = Star(color: UIColor.whiteColor(), size: CGSize(width: 2, height: 2))
            //star.position = CGPoint(x: xPos, y: yPos)
            star.worldX = xPos
            star.worldY = yPos
            newStarArray.addObject(star)
            //self.addChild(star)
        }
        return newStarArray
    }
    
    func getStarsForPosition(worldX: CGFloat, worldY: CGFloat) -> NSMutableArray {
        return generateStars(900)
    
    }
    
    func deriveScreenPosition(star: Star) {
        let starX = (star.worldX - hero.worldX) + (view!.frame.width / 2)
        let starY = (star.worldY - hero.worldY) + (view!.frame.height / 2)
        star.position = CGPoint(x: starX, y: starY)
    }
    
    func adjustHeroPosition() {
        var xAddition = hero.velocity * sin(hero.angle)
        var yAddition = hero.velocity * -cos(hero.angle)
        hero.worldX += xAddition
        hero.worldY += yAddition
    }
    
    
    
}
