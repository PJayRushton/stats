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
    
    @IBOutlet weak var singleButton: AtBatButton!
    @IBOutlet weak var doubleButton: AtBatButton!
    @IBOutlet weak var tripleButton: AtBatButton!
    @IBOutlet weak var hrButton: AtBatButton!
    @IBOutlet weak var strikeOutButton: AtBatButton!
    @IBOutlet weak var outButton: AtBatButton!
    @IBOutlet weak var rbisSegControl: BetterSegmentedControl!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var saveNextButton: CustomButton!
    
    fileprivate var allResultButtons: [AtBatButton] {
        return [singleButton, doubleButton, tripleButton, hrButton, strikeOutButton, outButton]
    }
    
    var editingAtBat: AtBat?
    var currentAtBatResult = AtBatCode.single
    var rbis = 0
    
    lazy var newAtBatRef: FIRDatabaseReference = {
        return StatsRefs.atBatsRef(teamId: App.core.state.teamState.currentTeam!.id).childByAutoId()
    }()
    
    fileprivate let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonCodes()
        if let editingAtBat = editingAtBat {
            update(with: editingAtBat)
        }
    }

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
        updateUI(with: state.atBatState.currentResult)
    }
    
}


extension AtBatCreationViewController {
    
    fileprivate func addButtonCodes() {
        singleButton.code = .single
        doubleButton.code = .double
        tripleButton.code = .triple
        hrButton.code = .hr
        strikeOutButton.code = .k
        outButton.code = .out
    }

    fileprivate func update(with atBat: AtBat) {
        updateUI(with: atBat.resultCode)
        deleteButton.isHidden = editingAtBat == nil
    }
    
    fileprivate func updateUI(with code: AtBatCode?) {
        allResultButtons.forEach { button in
            button.isSelected = button.code == code
        }
    }
    
    fileprivate func saveAtBat(next: Bool) {
        guard let atBat = constructedAtBat() else { return }
        core.fire(command: UpdateObject(object: atBat))
        
        if next {
            clear()
        }
    }
    
    fileprivate func constructedAtBat() -> AtBat? {
        let id = editingAtBat?.ref.key ?? newAtBatRef.key
        guard let game = core.state.gameState.currentGame else { return nil }
        guard let player = core.state.gameState.currentPlayer else { return nil }
        guard let season = core.state.seasonState.currentSeason else { return nil }
        guard let team = core.state.teamState.currentTeam else { return nil }
        let order = core.state.atBatState.atBats(for: player).count
        return AtBat(id: id, gameId: game.id, order: order, playerId: player.id, rbis: rbis, resultCode: currentAtBatResult, seasonId: season.id, teamId: team.id)
    }
    
    fileprivate func clear() {
    }
    
    fileprivate func showDeleteConfirmation() {
        guard let editingAtBat = editingAtBat else { return }
        let alert = Presentr.alertViewController(title: "Delete this at bat?", body: "This cannot be undone")
        alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            self.core.fire(command: DeleteObject(object: editingAtBat))
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }))
        customPresentViewController(presenter, viewController: alert, animated: true, completion: nil)
    }
    
}
