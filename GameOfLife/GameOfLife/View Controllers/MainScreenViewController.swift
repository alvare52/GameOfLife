//
//  MainScreenViewController.swift
//  GameOfLife
//
//  Created by Jorge Alvarez on 6/22/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import AVFoundation

class MainScreenViewController: UIViewController {

    // MARK: - Outlets
    
    @IBAction func clearBoardTapped(_ sender: UIBarButtonItem) {
        print("Clear board")
        gridScene.clearGrid()
    }
    
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        print("Info tapped")
        // go back to beginning of array if you're at the end
        if colorChoiceIndex == colors.count - 1 {
            colorChoiceIndex = 0
            infoButtonLabel.tintColor = .white // black
        } else {
            colorChoiceIndex += 1
            infoButtonLabel.tintColor = colors[colorChoiceIndex]
        }
//        lineBreak.backgroundColor = colors[colorChoiceIndex]
        gridScene.setColor(color: colors[colorChoiceIndex])
    }
    
    @IBOutlet var infoButtonLabel: UIBarButtonItem!
    
    @IBAction func speedButtonTapped(_ sender: UIButton) {
        print("speedButtonTapped")
        
        if durationChoiceIndex == durations.count - 1 {
            durationChoiceIndex = 0
        } else {
            durationChoiceIndex += 1
        }
        print("duration index = \(durationChoiceIndex)")
        if gameIsRunning {
            gridScene.stopLoop()
            gridScene.duration = durations[durationChoiceIndex]
            gridScene.startLoop()
        }
            
        else {
            gridScene.duration = durations[durationChoiceIndex]
        }
        
        switch durationChoiceIndex {
        case 1:
            speedButtonLable.setTitle("Fast", for: .normal)
        case 2:
            speedButtonLable.setTitle("Slow", for: .normal)
        default:
            speedButtonLable.setTitle("Medium", for: .normal)
        }
    }

    @IBOutlet var speedButtonLable: UIButton!
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        print("randomButtonTapped")
        gridScene.pickRandoms()
    }
    @IBOutlet var randomButtonLabel: UIButton!
    
    @IBOutlet var lineBreak: UIView!
    
    @IBOutlet var gridSKView: SKView!
    
    @IBOutlet var generationLabel: UILabel!
    
    @IBOutlet var startButtonLabel: UIButton!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("Start Button tapped")
        
        updateViews()
        
        // toggle start/stop and update button label
        
        if gameIsRunning {
            AudioServicesPlaySystemSound(SystemSoundID(1118))
            startButtonLabel.setTitle("Start", for: .normal)
            gridScene.stopLoop()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(1117))
            startButtonLabel.setTitle("Stop", for: .normal)
            gridScene.startLoop()
        }
        gameIsRunning.toggle()
    }
    
    // MARK: - Properties
    
    var generationCount: Int {
        return gridScene.generationCounter
    }
    
    var gameIsRunning = false
    
    let colors: [UIColor] = [.black, .red, .orange, .yellow, .green , .blue, .cyan,
                             .systemIndigo, .purple, .magenta, .systemPink]
    let durations: [Double] = [0.22, 0.11, 0.33]
    var colorChoiceIndex = 0
    var durationChoiceIndex = 0
    var corner: CGFloat = 5.0
    
    var gridScene: GridScene!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes status bar have white text
        navigationController?.navigationBar.barStyle = .black
        
        // Button corners
        startButtonLabel.layer.cornerRadius = corner
        speedButtonLable.layer.cornerRadius = corner
        randomButtonLabel.layer.cornerRadius = corner
        
        gridScene = GridScene(size: gridSKView.bounds.size)
        gridSKView.presentScene(gridScene)
//        gridSKView.presentScene(GridScene(size: gridSKView.bounds.size))
        print("GridScene view.bounds.size: \(view.bounds.size)")
        gridSKView.backgroundColor = .brown
        
        // Step 2
        NotificationCenter.default.addObserver(self,
        selector: #selector(updateViews),
        name: .updateGenLabel,
        object: nil)
        
    }
    
    // Step 3
    @objc private func updateViews() {
        generationLabel.text = "Generation \(gridScene.generationCounter)"
    }
    
    /// Adds current book to user's library and presents an action sheet to choose which shelf to put it in
    @objc func addBookToLibrary() {
        print("add button tapped")

        let act = UIAlertController(title: "Choose Preset", message: nil, preferredStyle: .actionSheet)
        act.addAction(UIAlertAction(title: "Oscillator", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "Random", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "Spaceship", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        act.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(act, animated: true)
    }

    /// Adds book to default shelf based on title selected
    private func addBookToDefaultShelves(action: UIAlertAction) {
        var readingStatus = 0
        switch action.title {
        case "Oscillator":
            readingStatus = 1
        case "Random":
            readingStatus = 2
        case "Spaceship":
            readingStatus = 3
        default:
            print(0)
        }
    }
}

// Step 1
extension NSNotification.Name {
    static let updateGenLabel = NSNotification.Name("updateGenLabel")
}
