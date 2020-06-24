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
    
    /// 2D array of Cells. Use [y][x] to access something instead of [x][y]
    var squareArray:[[Cell]] = [[]]
    
    /// White, same as background color
    var outlineColor: UIColor = .white
    var rightColor: UIColor = .black
    var wrongColor: UIColor = UIColor.black
    var hiddenColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    var rightCount: CGFloat = 0
    var touchEnabled = true
    var gridSize = 6
    var currentSquareIndexX = 0
    var currentSquareIndexY = 0
    
    override func didMove(to view: SKView) {
        
        //player.size = CGSize(width: frame.width, height: frame.height)
        // Background Color
        backgroundColor = .white
        print("Screen Height is \(self.frame.height), Width is \(self.frame.width)")
        makeGrid()
    }
    
    // TODO: swap PotentialNeighbor struct with a tuple
    func getPotentialNeighbors(x: Int, y: Int) -> [(x: Int, y: Int)] {
        print("getPotential Neighbors called with Cell: \(x) ,\(y)")
        var neighborinos = [(x: Int, y: Int)]()
        var realNeighborinos = [(x: Int, y: Int)]()
        
        let topLeft = (x: x - 1, y: y + 1)
        neighborinos.append(topLeft)
        
        let topMid = (x: x, y: y + 1)
        neighborinos.append(topMid)
        
        let topRight = (x: x + 1, y: y + 1)
        neighborinos.append(topRight)
        
        let left = (x: x - 1, y: y)
        neighborinos.append(left)
        
        let right = (x: x + 1, y: y)
        neighborinos.append(right)
        
        let bottomLeft = (x: x - 1, y: y - 1)
        neighborinos.append(bottomLeft)
        
        let bottomMid = (x: x, y: y - 1)
        neighborinos.append(bottomMid)
        
        let bottomRight = (x: x + 1, y: y - 1)
        neighborinos.append(bottomRight)
        
        var neighborinoCount = 0
        for potentialNeighbor in neighborinos {
            // Check if x AND y are between 0..<gridSize
            if 0..<gridSize ~= potentialNeighbor.x && 0..<gridSize ~= potentialNeighbor.y {
                print("ACTUAL Neighbor \(potentialNeighbor.x),\(potentialNeighbor.y)")
                neighborinoCount += 1
                realNeighborinos.append(potentialNeighbor)
            }
        }
        print("neighborinoCount = \(neighborinoCount)")
        print(realNeighborinos)
        return realNeighborinos
    }
    
    // how do i make x,y not have to be named? or tuple
//    struct PotentialNeighbor {
//        var x: Int
//        var y: Int
//    }
    
    // FIXME: cells are overlapping eachother, noticable with grids of 7 and up
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
            squareArray.append([Cell]())
            for x in 0..<gridSize{
                print("x: \(x), y: \(y)")
                let sprites = Cell(rectSize: CGSize(width: size, height: size))
//                print("sprites size starts as: \(sprites.frame.size)")

                sprites.fillColor = hiddenColor
                sprites.name = "Neutral"
                sprites.strokeColor = outlineColor
                sprites.lineWidth = size * CGFloat(0.05)// / CGFloat(10)

                let xPlacement: CGFloat = size * CGFloat(x) //+ CGFloat(1)
                let yPlacement: CGFloat = size * CGFloat(y) //+ CGFloat(1)
                
                //                              2 - 1 + ...
                let xBuffer: CGFloat = size / 2 - 1 + xLeftOver // (Width - (Floor(size) * 4)) / 2
                let yBuffer: CGFloat = size / 2 - 1 + yLeftOver // (Height - (size * 7)) / 2
                sprites.position = CGPoint(x: xPlacement + xBuffer, y: yPlacement + yBuffer)
//                print("position: \(sprites.position), size: \(sprites.frame.size)")

                self.addChild(sprites)
//                print("y: \(y), x: \(x)")
                sprites.x = x
                sprites.y = y
                squareArray[y].append(sprites)
//                print(sprites.description)
//                print(String(describing: sprites))
            }
        }
        
        print(squareArray.count)
    }
    
    func clearGrid(){
        for y in 0..<gridSize {
            for x in 0..<gridSize{
//                squareArray[y][x].fillColor = hiddenColor
//                squareArray[y][x].name = "Neutral"
                squareArray[y][x].currentState = .dead
                print("clearing [\(x)][\(y)]")
            }
        }
    }

    func pickRandoms() {
        print("pickRandoms called")
        clearGrid()
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                let random = Int.random(in: 0...2)
                if random == 1 {
//                    squareArray[y][x].fillColor = rightColor
//                    squareArray[y][x].name = "Alive"
                    squareArray[y][x].currentState = .alive
                    print("randomly picked [\(x)][\(y)]")
                }
            }
        }
    }
    
    func setNewGeneration() {
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                
                squareArray[y][x].currentState = squareArray[y][x].nextState
//                print("clearing [\(x)][\(y)]")
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
            setNewGeneration()
            return
        }
        
//        clearGrid()
        let current = squareArray[currentSquareIndexY][currentSquareIndexX]
        
        let neighbors = (getPotentialNeighbors(x: currentSquareIndexX, y: currentSquareIndexY))
        var liveNeighborsCount = 0
        
        for neighbor in neighbors {
            squareArray[neighbor.y][neighbor.x].fillColor = .green
            if squareArray[neighbor.y][neighbor.x].currentState == .alive {
                liveNeighborsCount += 1
            }
        }
        
        print("live neighbors = \(liveNeighborsCount)")
        
        // TODO: always revert back to dead anyway?
        
        // If ALIVE
        if current.currentState == .alive {
            // stay alive
            if liveNeighborsCount == 2 || liveNeighborsCount == 3 {
                current.nextState = .alive
            }
            // die
            else {
                current.nextState = .dead
            }
        }
        
        // If DEAD
        else {
            // come life
            if liveNeighborsCount == 3 {
                current.nextState = .alive
            }
            // stay dead
            else {
                current.nextState = .dead
            }
        }
        
        
//        current.currentState = .alive
        //current.fillColor = .purple
        print(current.description)
        print("current[\(currentSquareIndexX)][\(currentSquareIndexY)]")
        currentSquareIndexX += 1

        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.1),
            SKAction.run(runForever)
        ])
        )
    }
    
    // runs 60 times every SECOND
//    override func update(_ currentTime: CFTimeInterval) {
//        //checkIfBallReachesTheBottom()
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if let node = atPoint(location) as? Cell {
                print("tapped node at a location")
                if let theName = self.atPoint(location).name {
                    
                    if touchEnabled {
                        
                        if node.currentState == .dead {
                            print("tapped was dead, now alive")
//                            node.fillColor = rightColor
//                            node.name = "Alive"
                            node.currentState = .alive
                        } else {
                            print("tapped was alive, now dead")
//                            node.fillColor = hiddenColor
//                            node.name = "Neutral"
                            node.currentState = .dead
                        }
                        print(node.description)
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

/// Subclass of SKShapeNode
class Cell: SKShapeNode {
    
    /// Cells can either be dead or alive
    enum State {
        case alive
        case dead
    }
    
    // MARK: - Properties
    var currentState: State = .dead {
        didSet{
            if currentState == .dead {
                self.fillColor = deadColor
            }
            else {
                self.fillColor = aliveColor
            }
        }
    }
    
    /// currentState will be set to this during next generation
    var nextState: State = .dead
    
    /// Cell's X coordinate for 2D array of cells
    var x: Int = 0
    
    /// Cell's Y coordinate for 2D array of cells
    var y: Int = 0
    
    var aliveColor: UIColor = .black {
        didSet {
            self.fillColor = aliveColor
        }
    }
    
    override var description: String {
        return "(\(x), \(y)), State: \(currentState), nextState: \(nextState)"
    }
    
    var deadColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    
    init(rectSize: CGSize) {
        super.init()
        let shape = SKShapeNode(rectOf: rectSize)
        // Uses frame instead of making rect because the rect init with origin was
        // messing up the x for the whole grid
        self.path = CGPath(rect: shape.frame, transform: nil)
        self.fillColor = .gray
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
