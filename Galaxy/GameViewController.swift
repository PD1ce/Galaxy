//
//  GameViewController.swift
//  Galaxy
//
//  Created by Philip Deisinger on 6/1/15.
//  Copyright (c) 2015 PDice. All rights reserved.
//

import UIKit
import SpriteKit
//Comment 

/*extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! Galaxy
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}*/

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let galaxyScene = GalaxyScene(size: view.bounds.size)
            // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        galaxyScene.scaleMode = .AspectFill
        
        let hero = Hero(texture: SKTexture(imageNamed: "spaceShipTemp"), size: CGSize(width: 20, height: 20))
        //hero.size = CGSize(width: 20, height: 20)
        galaxyScene.hero = hero
        
        skView.presentScene(galaxyScene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
