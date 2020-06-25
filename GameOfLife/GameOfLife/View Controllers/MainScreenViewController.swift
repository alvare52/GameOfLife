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

class MainScreenViewController: UIViewController {

    // MARK: - Outlets
    
    @IBAction func clearBoardTapped(_ sender: UIBarButtonItem) {
        print("Clear board")
        
//        if gameIsRunning {
//            gridScene.stopLoop()
//            gridScene.duration = 0.5
//            gridScene.startLoop()
//        }
//
//        else {
//            gridScene.duration = 0.5
//        }
        
        gridScene.clearGrid()
    }
    
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        print("Info tapped")
        gridScene.pickRandoms()
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        print("colorButtonTapped")
        
        // go back to beginning of array if you're at the end
        if colorChoiceIndex == colors.count - 1 {
            colorChoiceIndex = 0
        } else {
            colorChoiceIndex += 1
        }
        gridScene.setColor(color: colors[colorChoiceIndex])
        colorButtonLabel.backgroundColor = colors[colorChoiceIndex]
    }
    
    @IBOutlet var colorButtonLabel: UIButton!
    
    @IBAction func speedButtonTapped(_ sender: UIButton) {
        print("speedButtonTapped")
    }

    @IBOutlet var speedButtonLable: UIButton!
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        print("randomButtonTapped")
        gridScene.pickRandoms()
    }
    @IBOutlet var randomButtonLabel: UIButton!
    
    @IBOutlet var gridSKView: SKView!
    
    @IBOutlet var generationLabel: UILabel!
    
    @IBOutlet var startButtonLabel: UIButton!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("Start Button tapped")
        
        updateViews()
        
        // toggle start/stop and update button label
        
        if gameIsRunning {
            startButtonLabel.setTitle("Start", for: .normal)
            gridScene.stopLoop()
        } else {
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
    var colorChoiceIndex = 0
    var corner: CGFloat = 10.0
    
    var gridScene: GridScene!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes status bar have white text
        navigationController?.navigationBar.barStyle = .black
        
        // Button corners
        startButtonLabel.layer.cornerRadius = corner
        colorButtonLabel.layer.cornerRadius = corner
        speedButtonLable.layer.cornerRadius = corner
        randomButtonLabel.layer.cornerRadius = corner
        
        gridScene = GridScene(size: gridSKView.bounds.size)
        gridSKView.presentScene(gridScene)
//        gridSKView.presentScene(GridScene(size: gridSKView.bounds.size))
        print("GridScene view.bounds.size: \(view.bounds.size)")
        
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
        print(readingStatus)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Step 1
extension NSNotification.Name {
    static let updateGenLabel = NSNotification.Name("updateGenLabel")
}
