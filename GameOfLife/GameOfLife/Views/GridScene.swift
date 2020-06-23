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
    
    /// White, same as background color
    var outlineColor: UIColor = .white
    var rightColor: UIColor = .black
    var wrongColor: UIColor = UIColor.black
    var hiddenColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    var rightCount: CGFloat = 0
    var touchEnabled = false
    var gridSize = 6
    var currentSquareIndex = 0
    
    override func didMove(to view: SKView) {
        
        //player.size = CGSize(width: frame.width, height: frame.height)
        // Background Color
        backgroundColor = .white
        print("Screen Height is \(self.frame.height), Width is \(self.frame.width)")
        makeGrid()
//        hideColors()
//        runForever()
        pickRandoms()
    }
    
    func makeGrid() {
        
        //for i in 0..<len
        //var i = 0
        //var a = 0
        // 125, 5x3, y: + 21
        // size = Floor(frame.width / 4 )
        print("X: \(frame.width) Y: \(frame.height)")
        print("Size should be \(floor(frame.width / CGFloat(gridSize)))")
        let size: CGFloat = floor((self.view?.frame.width)! / CGFloat(gridSize))
        print("size is \(size)")
        print("Containe View = \(self.view?.frame)")
        
        // left over from flooring
        print("frame.width: \(self.view?.frame.width)")
        let xLeftOver: CGFloat = ((self.view?.frame.width)! - size * CGFloat(gridSize)) / 2
        let yLeftOver: CGFloat = ((self.view?.frame.height)! - size * CGFloat(gridSize)) / 2

        print("xLeftOver = \(xLeftOver) yLeftOver = \(yLeftOver)")
        
        for row in 0..<gridSize{
            for col in 0..<gridSize{
                print("row: \(row), col: \(col)")
                let sprites = SKShapeNode(rectOf: CGSize(width: size, height: size))
                print("sprites size starts as: \(sprites.frame.size)")

                sprites.fillColor = hiddenColor
                sprites.name = "Neutral"
                sprites.strokeColor = outlineColor
                sprites.lineWidth = size * CGFloat(0.05)// / CGFloat(10)

                let xPlacement: CGFloat = size * CGFloat(col) + CGFloat(1)
                let yPlacement: CGFloat = size * CGFloat(row) + CGFloat(1)
                let xBuffer: CGFloat = size / 2 - 1 + xLeftOver // (Width - (Floor(size) * 4)) / 2
                let yBuffer: CGFloat = size / 2 - 1 + yLeftOver // (Height - (size * 7)) / 2
                sprites.position = CGPoint(x: xPlacement + xBuffer, y: yPlacement + yBuffer)
                print("position: \(sprites.position), size: \(sprites.frame.size)")

                self.addChild(sprites)
                squareArray.append(sprites)
            }
        }
    }
    
    func clearGrid(){
        for square in squareArray {
            square.fillColor = outlineColor
        }
    }
    
    func pickRandoms() {
        for sqaure in squareArray {
            let random = Int.random(in: 0...2)
            if random == 1 {
                print(random)
                sqaure.fillColor = rightColor
            } else {
                print(random)
            }
        }
    }
    
    func runForever() {
        
        print("currentSquareIndex = \(currentSquareIndex)")
        
        if currentSquareIndex >= gridSize * gridSize {
            print("END")
            return
        }
        
        squareArray[currentSquareIndex].fillColor = .purple
        currentSquareIndex += 1
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.1),
            SKAction.run(runForever)
        ])
        )
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
                        
                        if node.name == "Neutral" {
                            node.fillColor = rightColor
                            node.name = "Alive"
                        } else {
                            node.fillColor = hiddenColor
                            node.name = "Neutral"
                        }
//                        node.fillColor = rightColor
                        let systemSoundID: SystemSoundID = 1104
                        AudioServicesPlaySystemSound (systemSoundID)
                    }

                }
            }
            
            print("location.x = \(location.x)")
        }
        print("Touched Anywhere")
    }
}
