//
//  AtBatCreationViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AIFlatSwitch
import BetterSegmentedControl
import Firebase
import Presentr
import Whisper

class AtBatCreationViewController: Component, AutoStoryboardInitializable {
    
    // MARK: - IBOutlets

    @IBOutlet weak var previousPlayerLabel: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var nextPlayerLabel: UILabel!
    @IBOutlet weak var singleButton: AtBatButton!
    @IBOutlet weak var doubleButton: AtBatButton!
    @IBOutlet weak var tripleButton: AtBatButton!
    @IBOutlet weak var hrButton: AtBatButton!
    @IBOutlet weak var fieldersChoiceButton: AtBatButton!
    @IBOutlet weak var sacButton: AtBatButton!
    @IBOutlet weak var inTheParkView: UIView!
    @IBOutlet weak var inTheParkSwitch: AIFlatSwitch!
    @IBOutlet weak var walkButton: AtBatButton!
    @IBOutlet weak var roeButton: AtBatButton!
    @IBOutlet weak var strikeOutButton: AtBatButton!
    @IBOutlet weak var outButton: AtBatButton!
    @IBOutlet weak var rbisSegControl: BetterSegmentedControl!
    @IBOutlet weak var outsStack: UIStackView!
    @IBOutlet var outButtons: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var saveNextButton: CustomButton!
    
    // MARK: - Public Properties
    
    var editingAtBat: AtBat?
    var showOpponentScoreEdit: () -> Void = { }
    
    
    // MARK: - Internal Properties
    
    fileprivate var currentGame: Game? {
        return core.state.gameState.currentGame
    }
    fileprivate var allResultButtons: [AtBatButton] {
        return [singleButton, doubleButton, tripleButton, hrButton, walkButton, roeButton, strikeOutButton, outButton, fieldersChoiceButton, sacButton]
    }
    fileprivate var rbis = 0
    fileprivate var currentPlayer: Player? {
        return core.state.gameState.currentPlayer
    }
    fileprivate var newAtBatRef: DatabaseReference {
        return StatsRefs.atBatsRef(teamId: core.state.teamState.currentTeam!.id).childByAutoId()
    }
    
    fileprivate var currentAtBatResult = AtBatCode.single {
        didSet {
            updateUI(with: currentAtBatResult)
        }
    }
    fileprivate var saveIsEnabled = true {
        didSet {
            saveButton.isEnabled = saveIsEnabled
            saveNextButton.isEnabled = saveIsEnabled
        }
    }
    fileprivate var isShowingITPSwitch = false {
        didSet {
            guard isShowingITPSwitch != oldValue else { return }
            toggleITPView(isHidden: !isShowingITPSwitch)
        }
    }
    fileprivate var isLastOut: Bool {
        guard let game = currentGame else { return false }
        return game.outs == 3 || (game.outs == 2 && currentAtBatResult.isOut)
    }
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleITPView(isHidden: true, animated: false)
        setUpButtons()
        setUpRBISegControl()
        
        let isEditing = editingAtBat != nil
        deleteButton.isHidden = !isEditing
        saveNextButton.isHidden = isEditing
        currentAtBatResult = .single
        
        if let editingAtBat = editingAtBat {
            update(with: editingAtBat)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.fire(event: Selected<AtBatCode>(.single))
    }
    
    // MARK: - IBActions

    @IBAction func resultButtonPressed(_ sender: AtBatButton) {
        let code = inTheParkSwitch.isSelected && sender.code == .hr ? .hrITP : sender.code
        core.fire(event: Selected<AtBatCode>(code))
    }
    
    @IBAction func itpChanged(_ sender: AIFlatSwitch) {
        guard hrButton.isSelected else { return }
        core.fire(event: Selected<AtBatCode>(sender.isSelected ? .hrITP : .hr))
    }
    
    @IBAction func rbisChanged(_ sender: BetterSegmentedControl) {
        rbis = Int(sender.index)
    }
    
    @IBAction func outButtonPressed(_ sender: UIButton) {
        guard let index = outButtons.index(of: sender), let game = currentGame else { return }
        
        if index == game.outs {
            updateOuts()
        } else {
            updateOuts(outs: game.outs - 1)
        }
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
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    override func update(with state: AppState) {
        currentAtBatResult = state.atBatState.currentResult
        
        // Player labels
        guard let game = state.gameState.currentGame else { return }
        currentPlayerLabel.text = currentPlayer?.name
        let lineup =  game.lineupIds.flatMap { state.playerState.player(withId: $0) }
        previousPlayerLabel.text = ""
        nextPlayerLabel.text = ""
        
        if let player = currentPlayer, let index = lineup.index(of: player) {
            if index > 0, case let previousPlayer = lineup[index - 1] {
                previousPlayerLabel.text = previousPlayer.name
            }
            if index < lineup.count - 1, case let nextPlayer = lineup[index + 1] {
                nextPlayerLabel.text = nextPlayer.name
            }
        }
        
        // Outs
        
        let outs = game.outs
        for (index, button) in outButtons.enumerated() {
            button.isEnabled = index <= outs
            
            if index > outs {
                button.alpha = 0
            } else if index == outs {
                button.alpha = 0.3
            } else {
                button.alpha = 1
            }
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
        fieldersChoiceButton.code = .fc
        sacButton.code = .sac
        roeButton.code = .roe
        strikeOutButton.code = .k
        outButton.code = .out
        
        allResultButtons.forEach { button in
            button.tintColor = UIColor.mainAppColor
        }
    }

    fileprivate func update(with atBat: AtBat) {
        outsStack.isHidden = true
        saveNextButton.isHidden = true
        core.fire(event: Selected<AtBatCode>(atBat.resultCode))
        currentAtBatResult = atBat.resultCode
        isShowingITPSwitch = atBat.resultCode.isHR
        inTheParkSwitch.isSelected = atBat.resultCode == .hrITP
        try? rbisSegControl.setIndex(UInt(atBat.rbis))
    }
    
    fileprivate func updateUI(with code: AtBatCode) {
        allResultButtons.forEach { button in
            button.isSelected = button.code == code
        }
        hrButton.isSelected = code.isHR
        isShowingITPSwitch = code.isHR
        
        if (code.isHR || code == .sac) && rbisSegControl.index == 0 {
            try? rbisSegControl.setIndex(1, animated: true)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.saveNextButton.isHidden = self.isLastOut || self.editingAtBat != nil
        }
    }
    
    fileprivate func toggleITPView(isHidden: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.inTheParkView.isHidden = isHidden
                self.inTheParkView.alpha = isHidden ? 0 : 1
            }
        } else {
            inTheParkView.isHidden = isHidden
        }
    }
    
    fileprivate func setUpRBISegControl() {
        let titles = ["0", "1", "2", "3", "4"]
        rbisSegControl.setUp(with: titles, fontSize: 20)
    }
    
    fileprivate func saveAtBat(next: Bool) {
        guard let atBat = constructedAtBat() else { return }
        saveIsEnabled = false
        let updateCommand = UpdateObject(atBat) { success in
            self.saveIsEnabled = true
            guard success else { return }
            self.handleAtBatSavedSuccessfully(atBat: atBat, next: next)
        }
        core.fire(command: updateCommand)
    }
    
    fileprivate func handleAtBatSavedSuccessfully(atBat: AtBat, next: Bool) {
        updateGameScore(atBat: atBat)
        if let _ = self.editingAtBat {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if next {
            clear()
        } else {
            dismiss(animated: true) { [weak self] in
                guard let weakSelf = self, weakSelf.isLastOut else { return }
                weakSelf.upInning()
                weakSelf.showOpponentScoreEdit()
            }
        }
        moveToNextBatter()
    }
    
    fileprivate func upInning() {
        guard var updatedGame = core.state.gameState.currentGame else { return }
        updatedGame.inning += 1
        updatedGame.outs = 0
        core.fire(command: UpdateObject(updatedGame))
    }
    
    fileprivate func updateOuts(outs: Int? = nil) {
        guard var game = currentGame else { return }
        game.outs = outs ?? game.outs + 1
        core.fire(command: UpdateObject(game))
    }
    
    fileprivate func moveToNextBatter() {
        guard let currentGame = core.state.gameState.currentGame, let player = currentPlayer else { return }
        var nextPlayerId = currentGame.lineupIds.first
        
        if player.id != currentGame.lineupIds.last, let index = currentGame.lineupIds.index(of: player.id) {
            nextPlayerId = currentGame.lineupIds[index + 1]
        }
        guard let nextId = nextPlayerId, let nextPlayer = core.state.playerState.player(withId: nextId) else { return }
        core.fire(event: Selected<Player>(nextPlayer))
    }
    
    fileprivate func constructedAtBat() -> AtBat? {
        if let editingAtBat = editingAtBat {
            return AtBat(id: editingAtBat.id, creationDate: editingAtBat.creationDate, gameId: editingAtBat.gameId, playerId: editingAtBat.playerId, rbis: rbis, resultCode: currentAtBatResult, seasonId: editingAtBat.seasonId, teamId: editingAtBat.teamId)
        } else {
            let id = newAtBatRef.key
            guard let game = core.state.gameState.currentGame else { return nil }
            guard let player = currentPlayer else { return nil }
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
            if delete {
                currentGame.score -= atBat.rbis
            } else {
                currentGame.score += atBat.rbis - editingAtBat.rbis
            }
        } else {
            currentGame.score = delete ? currentGame.score - atBat.rbis : currentGame.score + atBat.rbis
        }
        //Catch all
        currentGame.score = max(currentGame.score, 0)
        
        let updateCommand = UpdateObject(currentGame) { success in
            guard success && atBat.resultCode.isOut && !delete else { return }
            self.updateOuts()
        }
        core.fire(command: updateCommand)
    }
    
}
