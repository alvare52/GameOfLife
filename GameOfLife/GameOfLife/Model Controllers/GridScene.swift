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
    var gridSize = 25
    var currentSquareIndexX = 0
    var currentSquareIndexY = 0
    var duration: TimeInterval = 0.22
    var generationCounter = 0 {
        // Send notification every time generation count is changed to update label in VC
        didSet {
            // Step 4
            NotificationCenter.default.post(name: .updateGenLabel,
            object: self)
        }
    }
    
    override func didMove(to view: SKView) {
        //print("Screen Height is \(self.frame.height), Width is \(self.frame.width)")
        makeGrid()
    }
    
    // FIXME: cells are overlapping eachother, noticable with grids of 7 and up
    /// Makes a grid of Cells and appends each to squareArray
    private func makeGrid() {
        
        // Background Color
        backgroundColor = .white
        
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

                self.addChild(sprites)
                sprites.x = x
                sprites.y = y
                squareArray[y].append(sprites)
            }
        }
        
        print(squareArray.count)
    }
    
    // MARK: - Game Controls
    
    /// Changes color of living cells
    func setColor(color: UIColor) {
        print("called setColor")
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                squareArray[y][x].aliveColor = color
            }
        }
    }
        
    /// Sets all cells on grid to .dead
    func clearGrid(){
        print("clearGrid called")
        
        generationCounter = 0
        
        stopLoop()
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                squareArray[y][x].currentState = .dead
            }
        }
    }

    /// Clears grid, then randomly assigns 1/3 of cells to .alive
    func pickRandoms() {
        print("pickRandoms called")
        
        clearGrid()
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                let random = Int.random(in: 0...2)
                if random == 1 {
                    squareArray[y][x].currentState = .alive
                }
            }
        }
    }
    
    /// Starts loop that gets new generation of cells every x seconds
    func startLoop() {
        print("startLoop called")
        touchEnabled = false
        let sequence = SKAction.sequence([
            SKAction.run(getNextGeneration),
            SKAction.wait(forDuration: duration)
        ])
        let action = SKAction.repeatForever(sequence)
        run(action)
    }
    
    /// Removes all actions from scene
    func stopLoop() {
        print("stopLoop called")
        touchEnabled = true
        self.removeAllActions()
    }
    
    // MARK: - Game Logic
    
    // TODO: swap PotentialNeighbor struct with a tuple
    private func getPotentialNeighbors(x: Int, y: Int) -> [(x: Int, y: Int)] {
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
                neighborinoCount += 1
                realNeighborinos.append(potentialNeighbor)
            }
        }
        return realNeighborinos
    }
    
    /// Goes through each cell and sets their nextState to alive or dead based on how many live neighbors they have (no wrap around)
    private func getNextGeneration() {
        
        if currentSquareIndexX >= gridSize {
//            print("END y \(currentSquareIndexY), x's done")
            currentSquareIndexY += 1
            currentSquareIndexX = 0
        }
        
        if currentSquareIndexY >= gridSize {
            print("END")
            setNewGeneration()
            return
        }
        
        let current = squareArray[currentSquareIndexY][currentSquareIndexX]
        
        let neighbors = (getPotentialNeighbors(x: currentSquareIndexX, y: currentSquareIndexY))
        var liveNeighborsCount = 0
        
        for neighbor in neighbors {
            squareArray[neighbor.y][neighbor.x].fillColor = .green
            if squareArray[neighbor.y][neighbor.x].currentState == .alive {
                liveNeighborsCount += 1
            }
        }
                
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
        
        currentSquareIndexX += 1
        
        // recursion?
        getNextGeneration()
    }
    
    /// Sets every cell's currentState to their nextState (their "previous" state)
    private func setNewGeneration() {
        currentSquareIndexX = 0
        currentSquareIndexY = 0
        
        generationCounter += 1
        print("Generation: \(generationCounter)")
        
        for y in 0..<gridSize {
            for x in 0..<gridSize{
                squareArray[y][x].currentState = squareArray[y][x].nextState
            }
        }
    }
    
    // MARK: - Touch Handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if let node = atPoint(location) as? Cell {
                print("tapped node at a location")
                if let theName = self.atPoint(location).name {
                    
                    if touchEnabled {
                        
                        if node.currentState == .dead {
                            print("tapped was dead, now alive")
                            node.currentState = .alive
                        } else {
                            print("tapped was alive, now dead")
                            node.currentState = .dead
                        }
                        print(node.description)
                        let systemSoundID: SystemSoundID = 1104
                        AudioServicesPlaySystemSound (systemSoundID)
                    }

                }
            }
            print("location.x = \(location.x), location.y = \(location.y)")
        }
        print("Touched Anywhere")
    }
}
