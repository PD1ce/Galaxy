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
    var planets = NSMutableArray()
    var visibleChunks = Array<(Int32, Int32)>()
    
    var chunkStars = NSMutableArray()
    var chunkPlanets = NSMutableArray()
    
    var hero: Hero!
    
    var beginTouchPos: CGPoint!
    var endTouchPos: CGPoint!
    var beginTouchTime: NSTimeInterval!
    var endTouchTime: NSTimeInterval!
    
    var coordinatesLabel: UILabel!
    
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
        
        coordinatesLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 30, width: 200, height: 30))
        coordinatesLabel.textColor = UIColor.whiteColor()
        coordinatesLabel.font = UIFont(name: "Copperplate", size: 16.0)
        coordinatesLabel.text = "(\(hero.worldX), \(hero.worldX))"
        let coordinateX = String(format: "%5.2f", hero.worldX)
        let coordinateY = String(format: "%5.2f", hero.worldY)
        coordinatesLabel.text = "(\(coordinateX), \(coordinateY))"
        view.addSubview(coordinatesLabel)
        
        println("\(hero.position)")
        addChild(hero)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if touches.count > 1 {
            return
        } else {
            let touch = touches.first as! UITouch
            beginTouchPos = touch.locationInNode(self)
            beginTouchTime = touch.timestamp
//            println("====================================")
//            println("Touch: \(beginTouchPos)")
//            println("Touch Time: \(beginTouchTime)")
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
            /*
            println("Touch: \(endTouchPos)")
            println("Touch Vector X: \(endTouchPos.x - beginTouchPos.x)")
            println("Touch Vector Y: \(endTouchPos.y - beginTouchPos.y)")
            println("Touch Time: \(endTouchTime)")
            println("Full Touch Duration: \(endTouchTime - beginTouchTime)")
            */
            //println("====================================")
        }
        let xVec = beginTouchPos.x - endTouchPos.x
        let yVec = beginTouchPos.y - endTouchPos.y
        var angle = atan2(yVec, xVec) + CGFloat(M_PI / 2)
        //ata
        let rotate = SKAction.rotateToAngle(angle, duration: 0.5)
        hero.runAction(rotate)
        hero.angle = CGFloat(angle)
        hero.velocity = 50 - CGFloat(endTouchTime - beginTouchTime)

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        srand(0)
        for child in children {
            child.removeFromParent()
        }
        
        //stars.removeAllObjects()
        //stars = getStarsForPosition(hero.worldX, worldY: hero.worldY)
        //planets.removeAllObjects()
        //planets = getPlanetsForPosition(hero.worldX, worldY: hero.worldY)
        
        
        ///////////////////////////////////////////////////////////////
        visibleChunks.removeAll(keepCapacity: true)
        
        //PDAlert
        //Find the Hero's Chunk! -- Probably some bad rounding here
        let heroChunkX = floor(hero.worldX / 1000)
        let heroChunkY = floor(hero.worldY / 1000)
        hero.chunk = (Int32(heroChunkX), Int32(heroChunkY))
        
        visibleChunks = getVisibleChunks(hero.chunk)
        for chunk in visibleChunks {
            chunkStars = generateStarsForChunk(chunk)
            chunkPlanets = generatePlanetsForChunk(chunk)
            for star in chunkStars {
                deriveScreenPositionStar(star as! Star)
                addChild(star as! Star)
            }
            for planet in chunkPlanets {
                deriveScreenPositionPlanet(planet as! Planet)
                addChild(planet as! Planet)
            }
        }
        addChild(hero)
        adjustHeroPosition()
        
        if hero.velocity <= 1.0 {
            hero.velocity = 1.0
        } else {
            hero.velocity -= 0.5
        }
       
        
        
        updateTime--
        if updateTime == 0 {
            //println("\(hero.velocity)")
            updateTime = 60
            let coordinateX = String(format: "%6.2f", hero.worldX)
            let coordinateY = String(format: "%6.2f", hero.worldY)
            coordinatesLabel.text = "(\(coordinateX), \(coordinateY))"
            println("Chunk x: \(hero.chunk.0), Chunk y: \(hero.chunk.1)")
        }
    }
    

    func generateStarsForChunk(chunk: (Int32, Int32)) -> NSMutableArray {
        let newStarArray = NSMutableArray()
        let originX = chunk.0 * 1000
        let originY = chunk.1 * 1000
        
        // Figure out number of stars to generate and how to seed the random gen based on chunk!
        var seed = Int32((chunk.0 + 20) * (chunk.1 + 30))
        if seed < 0 {
            seed = seed * -1
        }
        srand(UInt32(seed))
        let numStars = Int(rand() % 100) + 1
        for var i = 0; i < numStars; i++ {
            let star = Star(color: UIColor.whiteColor(), size: CGSize(width: 2, height: 2))
            let xPos = originX + (rand() % 1000)
            let yPos = originY + (rand() % 1000)
            star.worldX = CGFloat(xPos)
            star.worldY = CGFloat(yPos)
            newStarArray.addObject(star)
        }
        return newStarArray
    }
    
    func generatePlanetsForChunk(chunk: (Int32, Int32)) -> NSMutableArray {
        let newPlanetArray = NSMutableArray()
        let originX = chunk.0 * 1000
        let originY = chunk.1 * 1000
        
        if chunk.0 == 10 && chunk.1 == 10 {
            let planet = Planet(color: UIColor.blueColor(), size: CGSize(width: 300, height: 300))
            planet.worldX = CGFloat(10500)
            planet.worldY = CGFloat(10500)
            newPlanetArray.addObject(planet)
        } else {
            // Figure out number of Planets to generate and how to seed the random gen based on chunk!
            var seed = Int32((chunk.0 + 20) * (chunk.1 + 30))
            if seed < 0 {
                seed = seed * -1
            }
            srand(UInt32(seed))
            let numPlanets = Int(rand() % 5) + 1
            for var i = 0; i < numPlanets; i++ {
                let planet = Planet(color: UIColor.redColor(), size: CGSize(width: 20, height: 20))
                let xPos = originX + (rand() % 1000)
                let yPos = originY + (rand() % 1000)
                planet.worldX = CGFloat(xPos)
                planet.worldY = CGFloat(yPos)
                newPlanetArray.addObject(planet)
            }
        }
        
        
        return newPlanetArray
    }
    
    
    func getVisibleChunks(chunk: (Int32, Int32)) -> Array<(Int32, Int32)> {
        var newChunks = Array<(Int32, Int32)>()

        let chunk1 = (chunk.0 - 1, chunk.1 + 1);    newChunks.append(chunk1)    // Top Left
        let chunk2 = (chunk.0, chunk.1 + 1);        newChunks.append(chunk2)    // Top Middle
        let chunk3 = (chunk.0 + 1, chunk.1 + 1);    newChunks.append(chunk3)    // Top Right
        let chunk4 = (chunk.0 - 1, chunk.1);        newChunks.append(chunk4)    // Middle Left
        let chunk5 = (chunk.0, chunk.1);            newChunks.append(chunk5)    // Middle Middle
        let chunk6 = (chunk.0 + 1, chunk.1);        newChunks.append(chunk6)    // Middle Right
        let chunk7 = (chunk.0 - 1, chunk.1 - 1);    newChunks.append(chunk7)    // Bottom Left
        let chunk8 = (chunk.0, chunk.1 - 1);        newChunks.append(chunk8)    // Bottom Middle
        let chunk9 = (chunk.0 + 1, chunk.1 - 1);    newChunks.append(chunk9)    // Bottom Right
        
        return newChunks
    }
    
    func deriveScreenPositionStar(star: Star) {
        let starX = (star.worldX - hero.worldX) + (view!.frame.width / 2)
        let starY = (star.worldY - hero.worldY) + (view!.frame.height / 2)
        star.position = CGPoint(x: starX, y: starY)
    }
    
    
    func deriveScreenPositionPlanet(planet: Planet) {
        let planetX = (planet.worldX - hero.worldX) + (view!.frame.width / 2)
        let planetY = (planet.worldY - hero.worldY) + (view!.frame.height / 2)
        planet.position = CGPoint(x: planetX, y: planetY)
    }
    
    func adjustHeroPosition() {
        var xAddition = hero.velocity * sin(hero.angle)
        var yAddition = hero.velocity * -cos(hero.angle)
        hero.worldX += xAddition
        hero.worldY += yAddition
    }
    

    
    
    
}
