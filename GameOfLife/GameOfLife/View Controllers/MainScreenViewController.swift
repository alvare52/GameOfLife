//
//  MainScreenViewController.swift
//  GameOfLife
//
//  Created by Jorge Alvarez on 6/22/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import SpriteKit

class MainScreenViewController: UIViewController {

    // MARK: - Outlets
    
    @IBAction func clearBoardTapped(_ sender: UIBarButtonItem) {
        print("Clear board")
        gridScene.clearGrid()
    }
    
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        print("Info tapped")
        gridScene.runForever()
    }
    
    @IBOutlet var gridSKView: SKView!
    
    @IBOutlet var generationLabel: UILabel!
    
    @IBOutlet var startButtonLabel: UIButton!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("Start Button tapped")
        generationCount += 1
        updateViews()
        
        // toggle start/stop and update button label
        gameIsRunning.toggle()
        if gameIsRunning {
            startButtonLabel.setTitle("Stop", for: .normal)
        } else {
            startButtonLabel.setTitle("Start", for: .normal)
        }
        
        gridScene.clearGrid()
        gridScene.pickRandoms()
        //addBookToLibrary()
    }
    
    // MARK: - Properties
    
    var generationCount = 0
    var gameIsRunning = false
    
    var gridScene: GridScene!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes status bar have white text
        navigationController?.navigationBar.barStyle = .black
        
        // Button corners
        startButtonLabel.layer.cornerRadius = 5
        gridScene = GridScene(size: gridSKView.bounds.size)
        gridSKView.presentScene(gridScene)
//        gridSKView.presentScene(GridScene(size: gridSKView.bounds.size))
        print("GridScene view.bounds.size: \(view.bounds.size)")
    }
    
    private func updateViews() {
        generationLabel.text = "Generation \(generationCount)"
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
