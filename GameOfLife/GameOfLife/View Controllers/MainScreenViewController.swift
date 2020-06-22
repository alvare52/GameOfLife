//
//  MainScreenViewController.swift
//  GameOfLife
//
//  Created by Jorge Alvarez on 6/22/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    // MARK: - Outlets
    
    @IBAction func clearBoardTapped(_ sender: UIBarButtonItem) {
        print("Clear board")
    }
    
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        print("Info tapped")
    }
    
    // MARK: - Properties
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes status bar have white text
        navigationController?.navigationBar.barStyle = .black
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
