//
//  GridScene.swift
//  GameOfLife
//
//  Created by Jorge Alvarez on 6/22/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation

class GridScene: SKScene {
    let player = SKShapeNode()
    var scoreLabel = SKLabelNode()
    var score: CGFloat = 0
    var ballSize: CGFloat = 120.0
    //let triangleShape = SKShapeNode()
    var triangleSize: CGFloat = 62.5
    let boundary = SKSpriteNode()
    var tri = SKShapeNode()
    var triangleSpeed = TimeInterval(1.4) // 1 and 0.3
    var spawnRate = TimeInterval(0.6) // 1.5 0.5
    var squareSize: CGFloat = 100
    var bufferSpace: CGFloat = 11.25
    var yBuffer: CGFloat = 3.9
    var squareArray:[SKShapeNode] = [SKShapeNode]() // Property in your class
    var outlineColor: UIColor = .lightGray
    var rightColor: UIColor = UIColor.red
    var wrongColor: UIColor = UIColor.black
    var hiddenColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    var rightCount: CGFloat = 0
    var touchEnabled = false
    var gridSize = 5
    
    override func didMove(to view: SKView) {
        
        //player.size = CGSize(width: frame.width, height: frame.height)
        // Background Color
        backgroundColor = outlineColor
        
        print("Screen Height is \(self.frame.height), Width is \(self.frame.width)")
        
        makeGrid()
        
//        run(SKAction.sequence([
//            SKAction.wait(forDuration: 2),
//            SKAction.run(hideColors)
//            ])
//        )
        hideColors()
    }
    
    func makeGrid() {
        
        //for i in 0..<len
        //var i = 0
        //var a = 0
        // 125, 5x3, y: + 21
        // size = Floor(frame.width / 4 )
        print("X: \(frame.width) Y: \(frame.height)")
        print("Size should be \(floor(frame.width / CGFloat(gridSize)))")
        let size: CGFloat = floor(frame.width / CGFloat(gridSize))
        print("size is \(size)")
        
        let xLeftOver: CGFloat = (frame.width - size * CGFloat(gridSize)) / 2
        let yLeftOver: CGFloat = (frame.height - size * CGFloat(gridSize)) / 2
        print("xLeftOver = \(xLeftOver) yLeftOver = \(yLeftOver)")
        for row in 0...gridSize {
            for col in 0...gridSize {
                //let sprites = SKSpriteNode(color: .red, size: CGSize(width: size, height: size))
                let sprites = SKShapeNode(rectOf: CGSize(width: size, height: size * 2))
                
                sprites.fillColor = hiddenColor
                sprites.name = "Neutral"
                
                sprites.strokeColor = outlineColor
                sprites.lineWidth = size * CGFloat(0.1)// / CGFloat(10)
                let xPlacement: CGFloat = size * CGFloat(col) + CGFloat(1)
                let yPlacement: CGFloat = size * CGFloat(row) + CGFloat(1)
                let xBuffer: CGFloat = size / 2 - 1 + xLeftOver // (Width - (Floor(size) * 4)) / 2
                let yBuffer: CGFloat = size / 2 + yLeftOver // (Height - (size * 7)) / 2
                //sprites.position = CGPoint(x: (size * col + 1) + size / 2 - 1, y: (size * row + 1) + size / 2 + 7)
                sprites.position = CGPoint(x: xPlacement + xBuffer, y: yPlacement + yBuffer)
                self.addChild(sprites)
                squareArray.append(sprites)
            }
        }
    }
    
    func hideColors(){
        for square in squareArray {
            square.fillColor = hiddenColor
            touchEnabled = true
            //square.strokeColor = UIColor.black
            //square.lineWidth = 1
        }
    }
    
    func allWrong(){
        for square in squareArray {
            square.fillColor = wrongColor
            //backgroundColor = UIColor.red
            //square.strokeColor = UIColor.red
        }
        // Makes sound when you tap anywhere on screen
        //let systemSoundID: SystemSoundID = 1024
        //AudioServicesPlaySystemSound (systemSoundID)
        // CRASH
        //abort()
    }
    
    func allRight() {
        for square in squareArray {
            square.fillColor = rightColor
            //backgroundColor = UIColor.green
            //square.strokeColor = UIColor.green
        }
        // Makes sound when you tap anywhere on screen
        //let systemSoundID: SystemSoundID = 1025
        //AudioServicesPlaySystemSound (systemSoundID)
        
        print("You win!")
        
    }
    
    // runs 60 times every SECOND
    override func update(_ currentTime: CFTimeInterval) {
        //checkIfBallReachesTheBottom()
    }
    
    // returns random number
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    // returns random number between min and max
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func randomNumber(to: CGFloat) -> CGFloat {
        return random() * (to - 1) + 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if let node = atPoint(location) as? SKShapeNode {
                
                if let theName = self.atPoint(location).name {
                    
                    if touchEnabled {
                        node.fillColor = rightColor
                    }
//                    // If obstacles are touched (not needed)
//                    if theName == "Ball" && touchEnabled {
//                        //self.removeChildren(in: [self.atPoint(location)])
//                        node.isUserInteractionEnabled = true
//                        node.fillColor = rightColor
//                        // Makes sound when you tap anywhere on screen
//                        let systemSoundID: SystemSoundID = 1104
//                        AudioServicesPlaySystemSound (systemSoundID)
//                        score += 1
//                        print("RIGHT , Score = \(score)")
//                        scoreLabel.text = "Health = \(score)"
//                        if score == rightCount {
//                            allRight()
//                        }
//                    }
//
//                    if theName == "Bomb" && touchEnabled {
//                        //self.removeChildren(in: [self.atPoint(location)])
//                        node.isUserInteractionEnabled = true
//                        node.fillColor = wrongColor
//                        allWrong()
//                        print("WRONG")
//                        score = 0
//                        scoreLabel.text = "Health = \(score)"
//                    }
                }
                //node.isUserInteractionEnabled = true
                //node.fillColor = UIColor.red
            }
            
            print("location.x = \(location.x)")
            /*
             if let theName = self.atPoint(location).name {
             // If obstacles are touched (not needed)
             if theName == "Ball" {
             
             //self.removeChildren(in: [self.atPoint(location)])
             score += 1
             print("POP , Score = \(score)")
             scoreLabel.text = "Health = \(score)"
             }
             
             if theName == "Bomb" {
             //self.removeChildren(in: [self.atPoint(location)])
             print("BOOM")
             score = 0
             scoreLabel.text = "Health = \(score)"
             }
             }
             */
        }
        print("Touched Anywhere")
    }
}
