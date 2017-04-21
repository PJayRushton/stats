//
//  GameViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit
import LTMorphingLabel
import Presentr

class GameViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: LTMorphingLabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var previousInningButton: UIButton!
    @IBOutlet weak var inningLabel: LTMorphingLabel!
    @IBOutlet weak var nextInningButton: UIButton!
    @IBOutlet weak var playerPickerView: AKPickerView!
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var currentPlayer: Player? {
        return core.state.gameState.currentPlayer
    }
    var gamePlayers: [Player] {
        guard let game = game else { return [] }
        return game.lineupIds.flatMap { $0.statePlayer }
    }
    var currentAtBats: [AtBat] {
        guard let player = currentPlayer, let game = game else { return [] }
        return core.state.atBatState.atBats(for: player, in: game).sorted(by: { $0.creationDate > $1.creationDate })
    }
    
    var game: Game? {
        return core.state.gameState.currentGame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        guard let game = game else { return }
        
        if let firstPlayerId = game.lineupIds.first, let player = firstPlayerId.statePlayer {
            core.fire(event: Selected<Player>(player))
        }
        updateUI(with: game)
        scoreLabel.morphingEffect = .fall
        previousInningButton.tintColor = .gray400
        nextInningButton.tintColor = .gray400
        inningLabel.morphingEffect = .evaporate
        setUpPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scoreLabel.text = game?.scoreString
    }
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        showOptionsForGame()
    }
    
    @IBAction func inningArrowPressed(_ sender: UIButton) {
        guard let game = game else { return }
        let previousButtonWasPressed = sender == previousInningButton
        let newInning = previousButtonWasPressed ? game.inning - 1 : game.inning + 1
        updateInning(newInning)
    }
    
    func presentAtBatCreation() {
        let newAtBatVC = AtBatCreationViewController.initializeFromStoryboard()
        customPresentViewController(modalPresenter(), viewController: newAtBatVC, animated: true, completion: nil)
    }
    
    func presentAtBatEdit(atBat: AtBat) {
        let newAtBatVC = AtBatCreationViewController.initializeFromStoryboard()
        newAtBatVC.editingAtBat = atBat
        customPresentViewController(modalPresenter(), viewController: newAtBatVC, animated: true, completion: nil)
    }
    
    override func update(with state: AppState) {
        if let game = game {
            updateUI(with: game)
            updatePicker(game: game)
            if scoreLabel.text != "-" {
                scoreLabel.text = game.scoreString
            }
        }
        adapter.performUpdates(animated: true)
    }
    
}


extension GameViewController {
    
    fileprivate func updateUI(with game: Game) {
        if let team = core.state.teamState.currentTeam {
            awayTeamLabel.text = game.isHome ? game.opponent : team.name
            homeTeamLabel.text = game.isHome ? team.name : game.opponent
        }
        inningLabel.text = game.status
        previousInningButton.tintColor = game.inning == 1 ? .white : .gray400
        previousInningButton.isEnabled = game.inning > 1
    }
    
    fileprivate func updatePicker(game: Game) {
        guard let currentPlayer = core.state.gameState.currentPlayer,
            let index = game.lineupIds.index(of: currentPlayer.id),
            playerPickerView.selectedItem != index else { return }
        playerPickerView.scrollToItem(index, animated: true)
    }
    
    fileprivate func updateInning(_ inning: Int) {
        guard var updatedGame = game else { return }
        updatedGame.inning = inning
        core.fire(command: UpdateObject(updatedGame))
    }
    
    fileprivate func showOptionsForGame() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit Game ✏️", style: .default, handler: { _ in
            self.presentGameEditVC()
        }))
        alert.addAction(UIAlertAction(title: "Delete game ☠️", style: .destructive, handler: { _ in
            self.presentConfirmationAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentGameEditVC() {
        let gameCreationVC = GameCreationViewController.initializeFromStoryboard()
        gameCreationVC.editingGame = self.game
        let gameCreationNav = gameCreationVC.embededInNavigationController
        gameCreationVC.modalPresentationStyle = .overFullScreen
        present(gameCreationNav, animated: true, completion: nil)
    }
    
    fileprivate func presentConfirmationAlert() {
        let alert = Presentr.alertViewController(title: "Are you sure?", body: "This cannot be undone")
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            guard let game = self.game else { return }
            self.core.fire(command: DeleteGame(game))
        }))
            alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}


extension GameViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects = [IGListDiffable]()
        for (index, atBat) in currentAtBats.enumerated() {
            objects.append(AtBatSection(atBat: atBat, order: currentAtBats.count - index))
        }
        let newAtBatSection = NewAtBatSection()
        objects.insert(newAtBatSection, at: 0)
        return objects
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case _ as NewAtBatSection:
            let newAtBatSectionController = NewAtBatSectionController()
            newAtBatSectionController.cellSelected = presentAtBatCreation
            return newAtBatSectionController
        case _ as AtBatSection:
            let atBatSectionController = AtBatSectionController()
            atBatSectionController.didSelectAtBat = { atBat in
                self.presentAtBatEdit(atBat: atBat)
            }
            
            return atBatSectionController
        default:
            fatalError()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}

extension GameViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func setUpPickerView() {
        playerPickerView.delegate = self
        playerPickerView.dataSource = self
        playerPickerView.font = FontType.lemonMilk.font(withSize: 15)
        playerPickerView.highlightedFont = FontType.lemonMilk.font(withSize: 16)
        playerPickerView.highlightedTextColor = UIColor.secondaryAppColor
        playerPickerView.interitemSpacing = 32
        playerPickerView.pickerViewStyle = .flat
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return gamePlayers.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return gamePlayers[item].name
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        core.fire(event: Selected<Player>(gamePlayers[item]))
    }
    
}
