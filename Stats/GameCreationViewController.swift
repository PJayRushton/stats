//
//  GameCreationViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/17/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import Firebase
import TextFieldEffects

class GameCreationViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var opponentTextField: MadokaTextField!
    @IBOutlet weak var homeAwaySegControl: BetterSegmentedControl!
    @IBOutlet weak var regSeasonSegControl: BetterSegmentedControl!
    @IBOutlet weak var dateTextField: MadokaTextField!
    @IBOutlet weak var lineupView: UIView!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet var keyboardAccessoryView: UIView!
    
    var editingGame: Game?
    
    fileprivate var date = Date() {
        didSet {
            dateTextField.text = date.gameDayString
        }
    }
    fileprivate let datePicker = UIDatePicker()
    fileprivate lazy var newGameRef: FIRDatabaseReference = {
        return StatsRefs.gamesRef(teamId: App.core.state.teamState.currentTeam!.id).childByAutoId()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI(with: editingGame)
        if let editingGame = editingGame {
            core.fire(event: LineupUpdated(players: editingGame.lineupIds.flatMap { $0.statePlayer }))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSaveButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        opponentTextField.becomeFirstResponder()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lineupViewPressed(_ sender: UITapGestureRecognizer) {
        let rosterVC = RosterViewController.initializeFromStoryboard()
        rosterVC.isLineup = true
        navigationController?.pushViewController(rosterVC, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let game = construtedGame() else { return }
        if let _ = editingGame {
            core.fire(command: UpdateObject(game))
        } else {
            core.fire(command: CreateGame(game: game))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        if opponentTextField.isFirstResponder {
            dateTextField.becomeFirstResponder()
        } else {
            view.endEditing(false)
        }
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        if dateTextField.isFirstResponder {
            opponentTextField.becomeFirstResponder()
        } else {
            view.endEditing(false)
        }
    }
    
    @IBAction func keyboardPressed(_ sender: UIButton) {
        view.endEditing(false)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func homeAwayChanged(_ sender: BetterSegmentedControl) {
        updateSaveButton()
    }
    
    @IBAction func seasonTypeChanged(_ sender: BetterSegmentedControl) {
        updateSaveButton()
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    override func update(with state: AppState) {
        navigationController?.navigationBar.barTintColor = state.currentMenuItem?.backgroundColor
        updateSaveButton()
    }
    
}


extension GameCreationViewController {
    
    fileprivate func setUpSegmentedControls() {
        let homeAwayTitles = ["Home", "Away"]
        homeAwaySegControl.setUp(with: homeAwayTitles)
        
        let regSeasonTitles = ["Regular Season", "Post Season"]
        regSeasonSegControl.setUp(with: regSeasonTitles)
    }

    fileprivate func setUpDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputAccessoryView = keyboardAccessoryView
        dateTextField.inputView = datePicker
    }
    
    fileprivate func updateUI(with game: Game?) {
        navigationController?.navigationBar.barTintColor = HomeMenuItem.newGame.backgroundColor
        opponentTextField.inputAccessoryView = keyboardAccessoryView
        setUpSegmentedControls()
        setUpDatePicker()
        date = Date().nearestHalfHour

        guard let game = game else { return }
        title = "Edit Game"
        opponentTextField.text = game.opponent
        try? homeAwaySegControl.setIndex(game.isHome ? 0 : 1)
        try? regSeasonSegControl.setIndex(game.isRegularSeason ? 0 : 1)
        date = game.date
        if !game.lineupIds.isEmpty {
            
        }
    }
    
    fileprivate func updateSaveButton() {
        let newGame = construtedGame()
        if let editingGame = editingGame {
            startButton.isEnabled = newGame != nil && !newGame!.isTheSame(as: editingGame)
        } else {
            startButton.isEnabled = newGame != nil
        }
        
        let hasValidLineup = core.state.newGameState.lineup != nil && !core.state.newGameState.lineup!.isEmpty
        lineupView.backgroundColor = hasValidLineup ? UIColor.mainAppColor : UIColor.mainAppColor.withAlphaComponent(0.5)
    }
    
    fileprivate func construtedGame() -> Game? {
        guard let opponentText = opponentTextField.text, !opponentText.isEmpty else { print("Opponent can't be empty"); return nil }
        guard let currentTeam = core.state.teamState.currentTeam else { print("current team can't be nil"); return nil }
        guard let currentSeasonId = currentTeam.currentSeasonId else { print("curentseason can't be nil"); return nil }
        let isHome = homeAwaySegControl.index == 0
        let isRegularSeason = regSeasonSegControl.index == 0
        guard let lineup = core.state.newGameState.lineup else { return nil }
        let lineupIds = lineup.map { $0.id }
        guard !lineupIds.isEmpty else { print("Lineup can't be empty"); return nil }
        
        if var editingGame = editingGame {
            editingGame.opponent = opponentText
            editingGame.isHome = isHome
            editingGame.isRegularSeason = isRegularSeason
            editingGame.lineupIds = lineupIds
            return editingGame
        } else {
            return Game(id: newGameRef.key, date: date, inning: 1, isCompleted: false, isHome: isHome, isRegularSeason: isRegularSeason, lineupIds: lineupIds,opponent: opponentText, seasonId: currentSeasonId, teamId: currentTeam.id)
        }
    }
    
}


extension GameCreationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == dateTextField else { return }
        datePicker.setDate(date, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == opponentTextField {
            dateTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
