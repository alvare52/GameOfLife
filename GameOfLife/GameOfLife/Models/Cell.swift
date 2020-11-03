//
//  Cell.swift
//  GameOfLife
//
//  Created by Jorge Alvarez on 6/25/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import SpriteKit

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
    
    /// Color used to represent a living cell (defaults to .black). Automatically updates color when set
    var aliveColor: UIColor = .black {
        didSet {
            if self.currentState == .alive {
                self.fillColor = aliveColor
            }
        }
    }
    
    /// Returns a string that contains the cell's x,y, currentState and nextState in a nice format
    override var description: String {
        return "(\(x), \(y)), State: \(currentState), nextState: \(nextState)"
    }
    
    /// Color used to represent a dead cell (very light gray)
    var deadColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
    
    // MARK: - Initializers
    
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
