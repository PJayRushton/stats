//
//  OpponentScoreViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/12/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr

class OpponentScoreViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var accessoryView: UIView!
    @IBOutlet weak var minusButton: CustomButton!
    
    fileprivate var currentGame: Game? {
        return core.state.gameState.currentGame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentNameLabel.text = currentGame?.opponent ?? "--"
        textField.inputAccessoryView = accessoryView
        plusButton.cornerRadius = 5
        minusButton.cornerRadius = 5
        minusButton.disabledBackgroundColor = UIColor.secondaryAppColor.withAlphaComponent(0.5)
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        stepScore(up: true)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        guard let currentGame = currentGame, currentGame.opponentScore > 0 else { return }
        stepScore(up: false)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let scoreString = sender.text, let score = Int(scoreString) else { return }
        updateScore(score: score)
    }
    
    override func update(with state: AppState) {
        guard let opponentScore = state.gameState.currentGame?.opponentScore else { return }
        textField.text = String(opponentScore)
        minusButton.isEnabled = opponentScore > 0
    }
    
    fileprivate func stepScore(up: Bool) {
        guard var currentGame = currentGame else { return }
        currentGame.opponentScore = up ? currentGame.opponentScore + 1 : currentGame.opponentScore - 1
        core.fire(command: UpdateObject(currentGame))
    }
    
    fileprivate func updateScore(score: Int) {
        guard var currentGame = currentGame else { return }
        currentGame.opponentScore = score
        core.fire(command: UpdateObject(currentGame))
    }
    
}
