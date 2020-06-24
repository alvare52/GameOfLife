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
   
    // MARK: - Properties
    
    var squareArray:[[SKShapeNode]] = [[]]
    
    /// White, same as background color
    var outlineColor: UIColor = .white
    var rightColor: UIColor = .black
    var wrongColor: UIColor = UIColor.black
    var hiddenColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    var rightCount: CGFloat = 0
    var touchEnabled = true
    var gridSize = 5
    var currentSquareIndexX = 0
    var currentSquareIndexY = 0
    var singleArray: [SKShapeNode] = [SKShapeNode]()
    
    override func didMove(to view: SKView) {
        
        //player.size = CGSize(width: frame.width, height: frame.height)
        // Background Color
        backgroundColor = .white
        print("Screen Height is \(self.frame.height), Width is \(self.frame.width)")
        makeGrid()
//        hideColors()
        runForever()
//        pickRandoms()
        getPotentialNeighbors(x: 4, y: 1)
    }
    
    func getPotentialNeighbors(x: Int, y: Int) {
        print("getPotential Neighbors called with Cell: \(x) ,\(y)")
        var neighbors = [PotentialNeighbor]()
        
        let topLeft = PotentialNeighbor(x: x - 1, y: y + 1)
        neighbors.append(topLeft)
        
        let topMid = PotentialNeighbor(x: x, y: y + 1)
        neighbors.append(topMid)
        
        let topRight = PotentialNeighbor(x: x + 1, y: y + 1)
        neighbors.append(topRight)
        
        let left = PotentialNeighbor(x: x - 1, y: y)
        neighbors.append(left)
        
        let right = PotentialNeighbor(x: x + 1, y: y)
        neighbors.append(right)
        
        let bottomLeft = PotentialNeighbor(x: x - 1, y: y - 1)
        neighbors.append(bottomLeft)
        
        let bottomMid = PotentialNeighbor(x: x, y: y - 1)
        neighbors.append(bottomMid)
        
        let bottomRight = PotentialNeighbor(x: x + 1, y: y - 1)
        neighbors.append(bottomRight)
        
        for potentialNeighbor in neighbors {
            // Check if x AND y are between 0..<gridSize
            if 0..<gridSize ~= potentialNeighbor.x && 0..<gridSize ~= potentialNeighbor.y {
                print("ACTUAL Neighbor \(potentialNeighbor.x),\(potentialNeighbor.y)")
            }
        }
    }
    
    // how do i make x,y not have to be named? or tuple
    struct PotentialNeighbor {
        var x: Int
        var y: Int
    }
    
    private func makeGrid() {
        
        print("X: \(frame.width) Y: \(frame.height)")
        print("Size should be \(floor(frame.width / CGFloat(gridSize)))")
        let size: CGFloat = floor((self.view?.frame.width)! / CGFloat(gridSize))
        print("size is \(size)")
        
        // left over from flooring
        let xLeftOver: CGFloat = ((self.view?.frame.width)! - size * CGFloat(gridSize)) / 2
        let yLeftOver: CGFloat = ((self.view?.frame.height)! - size * CGFloat(gridSize)) / 2

        print("xLeftOver = \(xLeftOver) yLeftOver = \(yLeftOver)")
        
        for y in 0..<gridSize{
            
            // append a new array for every row
            squareArray.append([SKShapeNode]())
            for x in 0..<gridSize{
                print("x: \(x), y: \(y)")
                let sprites = SKShapeNode(rectOf: CGSize(width: size, height: size))
                print("sprites size starts as: \(sprites.frame.size)")

                sprites.fillColor = hiddenColor
                sprites.name = "Neutral"
                sprites.strokeColor = outlineColor
                sprites.lineWidth = size * CGFloat(0.05)// / CGFloat(10)

                let xPlacement: CGFloat = size * CGFloat(x) + CGFloat(1)
                let yPlacement: CGFloat = size * CGFloat(y) + CGFloat(1)
                let xBuffer: CGFloat = size / 2 - 1 + xLeftOver // (Width - (Floor(size) * 4)) / 2
                let yBuffer: CGFloat = size / 2 - 1 + yLeftOver // (Height - (size * 7)) / 2
                sprites.position = CGPoint(x: xPlacement + xBuffer, y: yPlacement + yBuffer)
                print("position: \(sprites.position), size: \(sprites.frame.size)")

                self.addChild(sprites)
                print("y: \(y), x: \(x)")
                squareArray[y].append(sprites)
            }
        }
       
        print(squareArray.count)
    }
    
    func clearGrid(){
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                
//                switch y {
//                case 0:
//                    squareArray[y][x].fillColor = .red
//                case 1:
//                    squareArray[y][x].fillColor = .orange
//                case 2:
//                    squareArray[y][x].fillColor = .yellow
//                case 3:
//                    squareArray[y][x].fillColor = .green
//                case 4:
//                    squareArray[y][x].fillColor = .blue
//                default:
//                    squareArray[y][x].fillColor = .brown
//                }
                
                squareArray[y][x].fillColor = hiddenColor
                print("clearing [\(x)][\(y)]")
            }
        }
    }

    func pickRandoms() {
        print("pickRandoms called")
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                let random = Int.random(in: 0...2)
                if random == 1 {
                    squareArray[y][x].fillColor = rightColor
                    print("randomly picked [\(x)][\(y)]")
                }
            }
        }
    }

    func runForever() {

//        print("currentSquareIndexX = \(currentSquareIndexX)")

        if currentSquareIndexX >= gridSize {
            print("END y \(currentSquareIndexY), x's done")
            currentSquareIndexY += 1
            currentSquareIndexX = 0
        }
        
        if currentSquareIndexY >= gridSize {
            print("END")
            return
        }
        
        let current = squareArray[currentSquareIndexY][currentSquareIndexX]
        current.fillColor = .purple
        print("current[\(currentSquareIndexX)][\(currentSquareIndexY)]")
        currentSquareIndexX += 1

        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.25),
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
                print("tapped node at a location")
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
