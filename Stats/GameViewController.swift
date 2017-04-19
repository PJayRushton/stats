//
//  GameViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class GameViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func update(with state: AppState) {
        label.text = "\(state.gameState.currentGame?.date.longStyleDateString) vs. \(state.gameState.currentGame?.opponent)"
    }
    
}
