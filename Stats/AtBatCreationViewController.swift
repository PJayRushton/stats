//
//  AtBatCreationViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import Firebase
import Presentr
import Whisper

class AtBatCreationViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var previousPlayerLabel: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var nextPlayerLabel: UILabel!
    @IBOutlet weak var singleButton: AtBatButton!
    @IBOutlet weak var doubleButton: AtBatButton!
    @IBOutlet weak var tripleButton: AtBatButton!
    @IBOutlet weak var hrButton: AtBatButton!
    @IBOutlet weak var walkButton: AtBatButton!
    @IBOutlet weak var roeButton: AtBatButton!
    @IBOutlet weak var strikeOutButton: AtBatButton!
    @IBOutlet weak var outButton: AtBatButton!
    @IBOutlet weak var rbisSegControl: BetterSegmentedControl!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var saveNextButton: CustomButton!
    
    fileprivate var allResultButtons: [AtBatButton] {
        return [singleButton, doubleButton, tripleButton, hrButton, walkButton, roeButton, strikeOutButton, outButton]
    }
    
    var editingAtBat: AtBat?
    
    fileprivate var currentAtBatResult = AtBatCode.single
    fileprivate var rbis = 0
    fileprivate var player: Player? {
        return core.state.gameState.currentPlayer
    }
    fileprivate var saveIsEnabled = true {
        didSet {
            saveButton.isEnabled = saveIsEnabled
            saveNextButton.isEnabled = saveIsEnabled
        }
    }
    var newAtBatRef: FIRDatabaseReference {
        return StatsRefs.atBatsRef(teamId: core.state.teamState.currentTeam!.id).childByAutoId()
    }
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtons()
        setUpRBISegControl()
        deleteButton.isHidden = editingAtBat == nil
        updateUI(with: nil)
        
        if let editingAtBat = editingAtBat {
            update(with: editingAtBat)
        }
    }

    
    // MARK: - IBActions

    @IBAction func resultButtonPressed(_ sender: AtBatButton) {
        core.fire(event: Selected<AtBatCode>(sender.code))
    }
    
    @IBAction func rbisChanged(_ sender: BetterSegmentedControl) {
        rbis = Int(sender.index)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        showDeleteConfirmation()
    }
    
    @IBAction func saveButtonPressed(_ sender: CustomButton) {
        saveAtBat(next: false)
    }
    
    @IBAction func saveNextButtonPressed(_ sender: CustomButton) {
        saveAtBat(next: true)
    }
    
    override func update(with state: AppState) {
        currentPlayerLabel.text = player?.name
        currentAtBatResult = state.atBatState.currentResult ?? .single
        updateUI(with: state.atBatState.currentResult)
        
        guard let game = state.gameState.currentGame else { return }
        if let player = player, let index = game.lineupIds.index(of: player.id), index > 0, let previousPlayer = game.lineupIds[index - 1].statePlayer {
            previousPlayerLabel.text = previousPlayer.name
        } else {
            previousPlayerLabel.text = nil
        }
        if let player = player, let index = game.lineupIds.index(of: player.id), index < game.lineupIds.count - 1, let nextPlayer = game.lineupIds[index + 1].statePlayer {
            nextPlayerLabel.text = nextPlayer.name
        } else {
            nextPlayerLabel.text = nil
        }
    }
    
}


// MARK: - Internal

extension AtBatCreationViewController {
    
    fileprivate func setUpButtons() {
        singleButton.code = .single
        doubleButton.code = .double
        tripleButton.code = .triple
        hrButton.code = .hr
        walkButton.code = .w
        roeButton.code = .roe
        strikeOutButton.code = .k
        outButton.code = .out
        
        allResultButtons.forEach { button in
            button.tintColor = UIColor.mainAppColor
        }
    }

    fileprivate func update(with atBat: AtBat) {
        updateUI(with: atBat.resultCode)
        try? rbisSegControl.setIndex(UInt(atBat.rbis), animated: true)
    }
    
    fileprivate func updateUI(with code: AtBatCode?) {
        allResultButtons.forEach { button in
            button.isSelected = button.code == code
        }
    }
    
    fileprivate func setUpRBISegControl() {
        let titles = ["0", "1", "2", "3", "4"]
        rbisSegControl.setUp(with: titles, fontSize: 18)
    }
    
    fileprivate func saveAtBat(next: Bool) {
        guard let atBat = constructedAtBat() else { print("Could not construct at bat"); return }
        saveIsEnabled = false
        let updateCommand = UpdateObject(atBat) { success in
            self.saveIsEnabled = true
            guard success else { return }
            
            DispatchQueue.main.async {
                self.updateGameScore(atBat: atBat)
                
                if next {
                    self.clear()
                    self.moveToNextBatter()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                if atBat.resultCode.isOut {
                    self.core.fire(event: OutAdded())
                }
            }
        }
        core.fire(command: updateCommand)
    }
    
    fileprivate func moveToNextBatter() {
        guard let currentGame = core.state.gameState.currentGame, let player = player else { return }
        var nextPlayerId = currentGame.lineupIds.first
        
        if player.id != currentGame.lineupIds.last, let index = currentGame.lineupIds.index(of: player.id) {
            nextPlayerId = currentGame.lineupIds[index + 1]
        }
        guard let nextPlayer = nextPlayerId?.statePlayer else { return }
        print("Selecting player: \(nextPlayer)")
        core.fire(event: Selected<Player>(nextPlayer))
    }
    
    fileprivate func constructedAtBat() -> AtBat? {
        if let editingAtBat = editingAtBat {
            return AtBat(id: editingAtBat.id, creationDate: editingAtBat.creationDate, gameId: editingAtBat.gameId, playerId: editingAtBat.playerId, rbis: rbis, resultCode: currentAtBatResult, seasonId: editingAtBat.seasonId, teamId: editingAtBat.teamId)
        } else {
            let id = newAtBatRef.key
            guard let game = core.state.gameState.currentGame else { return nil }
            guard let player = player else { return nil }
            guard let team = core.state.teamState.currentTeam else { return nil }
            guard let seasonId = team.currentSeasonId else { return nil }
            return AtBat(id: id, gameId: game.id, playerId: player.id, rbis: rbis, resultCode: currentAtBatResult, seasonId: seasonId, teamId: team.id)
        }
    }
    
    fileprivate func clear() {
        core.fire(event: Selected<AtBatCode>(.single))
        try? rbisSegControl.setIndex(0, animated: true)
        rbis = 0
    }
    
    fileprivate func showDeleteConfirmation() {
        guard let editingAtBat = editingAtBat else { return }
        let alert = Presentr.alertViewController(title: "Delete this at bat?", body: "This cannot be undone")
        alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            self.core.fire(command: DeleteObject(object: editingAtBat))
            self.updateGameScore(atBat: editingAtBat, delete: true)
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    fileprivate func updateGameScore(atBat: AtBat, delete: Bool = false) {
        guard var currentGame = core.state.gameState.currentGame else { return }
        
        if let editingAtBat = editingAtBat {
            currentGame.score += atBat.rbis - editingAtBat.rbis
        } else {
            currentGame.score = delete ? currentGame.score - atBat.rbis : currentGame.score + atBat.rbis
        }
        core.fire(command: UpdateObject(currentGame))
    }
    
}
