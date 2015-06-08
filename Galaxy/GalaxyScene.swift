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
    var maxSpeedLabel: UILabel!
    var cruisingSpeedLabel: UILabel!
    var resistanceLabel: UILabel!
    
    var toggleEnginesButton: UIButton!
    var previousCruisingSpeed: CGFloat!
    var enginesAreOn = true
    
    let rotateRight = SKAction.rotateToAngle(3.1415926 / 2, duration: 0.25)
    let rotateLeft = SKAction.rotateToAngle(-3.1415926 / 2, duration: 0.25)
    
    var updateTime = 60
    var increaseCruisingSpeedTimer = 300
    
    var middleOfScreen: CGPoint!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        middleOfScreen = view.center
        
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
        
        toggleEnginesButton = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 44))
        //toggleEnginesButton.backgroundColor = UIColor.blackColor()
        toggleEnginesButton.layer.borderWidth = 2.0
        toggleEnginesButton.layer.cornerRadius = 5.0
        toggleEnginesButton.layer.borderColor = UIColor.whiteColor().CGColor
        toggleEnginesButton.setTitle("X", forState: .Normal)
        toggleEnginesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        toggleEnginesButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        toggleEnginesButton.addTarget(self, action: "toggleEnginesTapped", forControlEvents: .TouchUpInside)
        
        /////////////////////////// Temp Buttons For Testing! //////////////////////////////
        let increaseMaxSpeedButton = UIButton(frame: CGRect(x: 0, y: 44, width: 44, height: 44))
        //increaseMaxSpeedButton.backgroundColor = UIColor.blackColor()
        increaseMaxSpeedButton.layer.borderWidth = 2.0
        increaseMaxSpeedButton.layer.cornerRadius = 5.0
        increaseMaxSpeedButton.layer.borderColor = UIColor.whiteColor().CGColor
        increaseMaxSpeedButton.setTitle("M+", forState: .Normal)
        increaseMaxSpeedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        increaseMaxSpeedButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        increaseMaxSpeedButton.addTarget(self, action: "increaseMaxSpeedTapped", forControlEvents: .TouchUpInside)
        let decreaseMaxSpeedButton = UIButton(frame: CGRect(x: 44, y: 44, width: 44, height: 44))
        //decreaseMaxSpeedButton.backgroundColor = UIColor.blackColor()
        decreaseMaxSpeedButton.layer.borderWidth = 2.0
        decreaseMaxSpeedButton.layer.cornerRadius = 5.0
        decreaseMaxSpeedButton.layer.borderColor = UIColor.whiteColor().CGColor
        decreaseMaxSpeedButton.setTitle("M-", forState: .Normal)
        decreaseMaxSpeedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        decreaseMaxSpeedButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        decreaseMaxSpeedButton.addTarget(self, action: "decreaseMaxSpeedTapped", forControlEvents: .TouchUpInside)
        
        let increaseCruisingSpeedButton = UIButton(frame: CGRect(x: 0, y: 132, width: 44, height: 44))
        //increaseCruisingSpeedButton.backgroundColor = UIColor.blackColor()
        increaseCruisingSpeedButton.layer.borderWidth = 2.0
        increaseCruisingSpeedButton.layer.cornerRadius = 5.0
        increaseCruisingSpeedButton.layer.borderColor = UIColor.whiteColor().CGColor
        increaseCruisingSpeedButton.setTitle("C+", forState: .Normal)
        increaseCruisingSpeedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        increaseCruisingSpeedButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        increaseCruisingSpeedButton.addTarget(self, action: "increaseCruisingSpeedTapped", forControlEvents: .TouchUpInside)
        let decreaseCruisingSpeedButton = UIButton(frame: CGRect(x: 44, y: 132, width: 44, height: 44))
        //decreaseCruisingSpeedButton.backgroundColor = UIColor.blackColor()
        decreaseCruisingSpeedButton.layer.borderWidth = 2.0
        decreaseCruisingSpeedButton.layer.cornerRadius = 5.0
        decreaseCruisingSpeedButton.layer.borderColor = UIColor.whiteColor().CGColor
        decreaseCruisingSpeedButton.setTitle("C-", forState: .Normal)
        decreaseCruisingSpeedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        decreaseCruisingSpeedButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        decreaseCruisingSpeedButton.addTarget(self, action: "decreaseCruisingSpeedTapped", forControlEvents: .TouchUpInside)
        
        let increaseResistanceButton = UIButton(frame: CGRect(x: 0, y: 220, width: 44, height: 44))
        //increaseResistanceButton.backgroundColor = UIColor.blackColor()
        increaseResistanceButton.layer.borderWidth = 2.0
        increaseResistanceButton.layer.cornerRadius = 5.0
        increaseResistanceButton.layer.borderColor = UIColor.whiteColor().CGColor
        increaseResistanceButton.setTitle("R+", forState: .Normal)
        increaseResistanceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        increaseResistanceButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        increaseResistanceButton.addTarget(self, action: "increaseResistanceTapped", forControlEvents: .TouchUpInside)
        let decreaseResistanceButton = UIButton(frame: CGRect(x: 44, y: 220, width: 44, height: 44))
        //decreaseResistanceButton.backgroundColor = UIColor.blackColor()
        decreaseResistanceButton.layer.borderWidth = 2.0
        decreaseResistanceButton.layer.cornerRadius = 5.0
        decreaseResistanceButton.layer.borderColor = UIColor.whiteColor().CGColor
        decreaseResistanceButton.setTitle("R-", forState: .Normal)
        decreaseResistanceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        decreaseResistanceButton.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        decreaseResistanceButton.addTarget(self, action: "decreaseResistanceTapped", forControlEvents: .TouchUpInside)
        
        maxSpeedLabel = UILabel(frame: CGRect(x: 0, y: 88, width: 88, height: 44))
        maxSpeedLabel.text = "\(hero.maxSpeed)"
        maxSpeedLabel.textColor = UIColor.whiteColor()
        maxSpeedLabel.font = UIFont(name: "Copperplate", size: 24.0)
        maxSpeedLabel.textAlignment = NSTextAlignment.Center
        maxSpeedLabel.layer.borderWidth = 2.0
        maxSpeedLabel.layer.cornerRadius = 5.0
        maxSpeedLabel.layer.borderColor = UIColor.whiteColor().CGColor
        cruisingSpeedLabel = UILabel(frame: CGRect(x: 0, y: 176, width: 88, height: 44))
        cruisingSpeedLabel.text = "\(hero.cruisingSpeed)"
        cruisingSpeedLabel.textColor = UIColor.whiteColor()
        cruisingSpeedLabel.font = UIFont(name: "Copperplate", size: 24.0)
        cruisingSpeedLabel.textAlignment = NSTextAlignment.Center
        cruisingSpeedLabel.layer.borderWidth = 2.0
        cruisingSpeedLabel.layer.cornerRadius = 5.0
        cruisingSpeedLabel.layer.borderColor = UIColor.whiteColor().CGColor
        resistanceLabel = UILabel(frame: CGRect(x: 0, y: 264, width: 88, height: 44))
        resistanceLabel.text = "\(hero.resistance)"
        resistanceLabel.textColor = UIColor.whiteColor()
        resistanceLabel.font = UIFont(name: "Copperplate", size: 24.0)
        resistanceLabel.textAlignment = NSTextAlignment.Center
        resistanceLabel.layer.borderWidth = 2.0
        resistanceLabel.layer.cornerRadius = 5.0
        resistanceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(increaseMaxSpeedButton)
        view.addSubview(decreaseMaxSpeedButton)
        view.addSubview(increaseCruisingSpeedButton)
        view.addSubview(decreaseCruisingSpeedButton)
        view.addSubview(increaseResistanceButton)
        view.addSubview(decreaseResistanceButton)
        
        view.addSubview(maxSpeedLabel)
        view.addSubview(cruisingSpeedLabel)
        view.addSubview(resistanceLabel)
        
        /////////////////////////// Temp Buttons For Testing! //////////////////////////////
        
        view.addSubview(toggleEnginesButton)
        
        
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
        hero.velocity = hero.maxSpeed - CGFloat(endTouchTime - beginTouchTime) * 10

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        srand(0)
        for child in children {
            child.removeFromParent()
        }
        
        ///////////////////////////////////////////////////////////////
        visibleChunks.removeAll(keepCapacity: true)
        
        //PDAlert
        //Find the Hero's Chunk! -- Probably some bad rounding here
        let heroChunkX = floor(hero.worldX / 1000)
        let heroChunkY = floor(hero.worldY / 1000)
        hero.chunk = (Int32(heroChunkX), Int32(heroChunkY))
        
        visibleChunks = getVisibleChunks(hero.chunk)
        for chunk in visibleChunks {
            //generateObjectsForChunk(chunk)
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
            
            //The object is in the same chunk as the hero
            if (chunk.0 == hero.chunk.0 && chunk.1 == hero.chunk.1) {
                for planet in chunkPlanets {
                    let collision = isInMiddleOfScreen(planet as! Planet)
                    if collision {
                        (planet as! Planet).displayInfo()
                    }
                }
            }
        }
        
        //Find the planet or object that is touching the middle of the screen?
        
        
        addChild(hero)
        adjustHeroPosition()
        
        if hero.velocity <= hero.cruisingSpeed {
            hero.velocity = hero.cruisingSpeed
        } else {
            //Resitance could be a property of the current chunk
            hero.velocity -= hero.resistance
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
    
    func getChunkSeedOne(chunkPart: Int32) -> Int64 {
        
        var seed: Int64 = Int64(chunkPart) * 3442925714
        seed *= hero.playerID
        
        return seed
    }
    func getChunkSeedTwo(chunkPart: Int32) -> Int64 {
        
        var seed: Int64 = Int64(chunkPart) * 9872346242
        seed *= hero.playerID
        
        return seed
    }
    
    func isInMiddleOfScreen(node: SKSpriteNode) -> Bool {
        let xPos = node.position.x
        let yPos = node.position.y
        let nodeLeftSide = xPos - node.frame.width / 2
        let nodeRightSide = xPos + node.frame.width / 2
        let nodeBottomSide = yPos - node.frame.height / 2
        let nodeTopSide = yPos + node.frame.height / 2
        
        //The Node is in contact with the middle of screen
        if (nodeLeftSide < middleOfScreen.x && nodeRightSide > middleOfScreen.x) && (nodeBottomSide < middleOfScreen.y && nodeTopSide > middleOfScreen.y) {
            return true
        }
        
        return false
    }
    
    
    func generateObjectsForChunk(chunk: (Int32, Int32)) -> NSMutableArray {
        let chunkObjectsArray = NSMutableArray()
        let seedOne = getChunkSeedOne(chunk.0)
        let seedTwo = getChunkSeedTwo(chunk.1)
        //// 0...7 seedOne + 63...56 seedTwo
        
        //// 8...15 seedOne + 55...48 seedTwo
        
        //// 16...23 seedOne + 47...40 seedTwo
        
        //// 24...31 seedOne + 39...32 seedTwo
        
        //// DELTAS /////
        
        
        
        return chunkObjectsArray
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
                
                let planet = Planet(texture: nil, color: UIColor.redColor(), size: CGSize(width: 20, height: 20), id: i)
                //let planet = Planet(color: UIColor.redColor(), size: CGSize(width: 20, height: 20))
                let xPos = originX + (rand() % 1000)
                let yPos = originY + (rand() % 1000)
                planet.worldX = CGFloat(xPos)
                planet.worldY = CGFloat(yPos)
                newPlanetArray.addObject(planet)
            }
            
            //Create planet based on seed
            if (chunk.0 * chunk.1) % 100 == 0 {
                let planet = Planet(color: UIColor.greenColor(), size: CGSize(width: 100, height: 100))
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
    
    //PDAlert: Probably a safer way to store this so its not lost
    func toggleEnginesTapped() {
        if enginesAreOn {
            enginesAreOn = false
            previousCruisingSpeed = hero.cruisingSpeed
            hero.cruisingSpeed = 0
            toggleEnginesButton.setTitle(">", forState: .Normal)
            
        } else {
            enginesAreOn = true
            hero.cruisingSpeed = previousCruisingSpeed
            previousCruisingSpeed = 0
            toggleEnginesButton.setTitle("X", forState: .Normal)
            
        }
    }
    
    func increaseMaxSpeedTapped() {
        hero.maxSpeed += 1
        maxSpeedLabel.text = "\(hero.maxSpeed)"
    }
    func decreaseMaxSpeedTapped() {
        hero.maxSpeed -= 1
        if hero.maxSpeed <= 2 {
            hero.maxSpeed = 2
        }
        maxSpeedLabel.text = "\(hero.maxSpeed)"
    }
    func increaseCruisingSpeedTapped() {
        hero.cruisingSpeed += 0.5
        cruisingSpeedLabel.text = "\(hero.cruisingSpeed)"
    }
    func decreaseCruisingSpeedTapped() {
        hero.cruisingSpeed -= 0.5
        if hero.cruisingSpeed <= 0.5 {
            hero.cruisingSpeed = 0.5
        }
        cruisingSpeedLabel.text = "\(hero.cruisingSpeed)"
    }
    func increaseResistanceTapped() {
        hero.resistance += 0.1
        resistanceLabel.text = "\(hero.resistance)"
    }
    func decreaseResistanceTapped() {
        hero.resistance -= 0.1
        if hero.resistance <= 0.1 {
            hero.resistance = 0.1
        }
        resistanceLabel.text = "\(hero.resistance)"
    }
    
    
    
}
