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
    
    // MARK: - IBOutlets

    @IBOutlet weak var opponentTextField: HoshiTextField!
    @IBOutlet weak var locationTextField: HoshiTextField!
    @IBOutlet weak var homeAwaySegControl: BetterSegmentedControl!
    @IBOutlet weak var regSeasonSegControl: BetterSegmentedControl!
    @IBOutlet weak var dateTextField: MadokaTextField!
    @IBOutlet weak var lineupView: UIView!
    @IBOutlet weak var lineupLabel: UILabel!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet var keyboardAccessoryView: UIView!
    
    
    // MARK: - Public
    
    var editingGame: Game?
    var showLineup = false
    
    fileprivate var date = Date() {
        didSet {
            dateTextField.text = date.gameDayString
        }
    }
    fileprivate let datePicker = UIDatePicker()
    fileprivate lazy var newGameRef: DatabaseReference = {
        return StatsRefs.gamesRef(teamId: App.core.state.teamState.currentTeam!.id).childByAutoId()
    }()
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI(with: editingGame)
        if let editingGame = editingGame {
            let lineupPlayers = editingGame.lineupIds.flatMap { core.state.playerState.player(withId: $0) }
            core.fire(event: LineupUpdated(players: lineupPlayers))
        }
        if showLineup {
            pushLineup(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .mainAppColor
        updateSaveButton()
        view.endEditing(false)
    }
    
    
    // MARK: - IBActions

    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lineupViewPressed(_ sender: Any) {
        pushLineup()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let game = construtedGame() else { return }
        if let _ = editingGame {
            core.fire(command: SetObject(game))
        } else {
            core.fire(command: CreateGame(game: game))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        if opponentTextField.isFirstResponder {
            locationTextField.becomeFirstResponder()
        } else if locationTextField.isFirstResponder {
            dateTextField.becomeFirstResponder()
        } else {
            view.endEditing(false)
        }
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        if dateTextField.isFirstResponder {
            locationTextField.becomeFirstResponder()
        } else if locationTextField.isFirstResponder {
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
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        updateSaveButton()
    }
    
}


// MARK: - Private

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
        opponentTextField.inputAccessoryView = keyboardAccessoryView
        locationTextField.inputAccessoryView = keyboardAccessoryView
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
    
    fileprivate func pushLineup(animated: Bool = true) {
        let rosterVC = RosterViewController.initializeFromStoryboard()
        rosterVC.isLineup = true
        navigationController?.pushViewController(rosterVC, animated: animated)
    }
    
    fileprivate func updateSaveButton() {
        let newGame = construtedGame()
        if let editingGame = editingGame {
            startButton.isEnabled = newGame != nil && !newGame!.isSame(as: editingGame)
        } else {
            startButton.isEnabled = newGame != nil
        }
        guard let currentLineup = core.state.newGameState.lineup else { return }
        lineupLabel.text = currentLineup.isEmpty ? "Set Lineup" : "Edit Lineup (\(currentLineup.count))"
    }
    
    fileprivate func construtedGame() -> Game? {
        guard let opponentText = opponentTextField.text, !opponentText.isEmpty else { print("Opponent can't be empty"); return nil }
        guard let currentTeam = core.state.teamState.currentTeam else { print("current team can't be nil"); return nil }
        guard let currentSeasonId = currentTeam.currentSeasonId else { print("curent season can't be nil"); return nil }
        var locationString = locationTextField.text
        if let locationText = locationTextField.text, locationText.isEmpty {
            locationString = nil
        }
        
        let isHome = homeAwaySegControl.index == 0
        let isRegularSeason = regSeasonSegControl.index == 0
        let lineupIds = core.state.newGameState.lineup?.flatMap { $0.id } ?? []
        
        if var editingGame = editingGame {
            editingGame.opponent = opponentText
            editingGame.location = locationString
            editingGame.isHome = isHome
            editingGame.isRegularSeason = isRegularSeason
            editingGame.lineupIds = lineupIds
            return editingGame
        } else {
            return Game(id: newGameRef.key, date: date, inning: 1, isCompleted: false, isHome: isHome, isRegularSeason: isRegularSeason, lineupIds: lineupIds, location: locationString, opponent: opponentText, seasonId: currentSeasonId, teamId: currentTeam.id)
        }
    }
    
}


// MARK: - TextField 

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
