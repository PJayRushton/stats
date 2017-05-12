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
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: LTMorphingLabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var previousInningButton: UIButton!
    @IBOutlet weak var inningLabel: LTMorphingLabel!
    @IBOutlet weak var nextInningButton: UIButton!
    @IBOutlet weak var playerPickerView: AKPickerView!
    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet var outButtons: [UIButton]!
    
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var customPresenter: Presentr {
        let customPresentation = PresentationType.custom(width: ModalSize.fluid(percentage: 0.8), height: .fluid(percentage: 0.8), center: .center)
        let presenter = Presentr(presentationType: customPresentation)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissTransitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }

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
    
    var names = [String]() {
        didSet {
            if names != oldValue {
                playerPickerView.reloadData()
            }
        }
    }
    var hasEditRights: Bool {
        guard let currentUser = core.state.userState.currentUser, let team = core.state.teamState.currentTeam else { return false }
        return currentUser.isOwnerOrManager(of: team)
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
        previousInningButton.isHidden = game.isCompleted || !hasEditRights
        nextInningButton.isHidden = game.isCompleted || !hasEditRights
        previousInningButton.tintColor = .gray400
        nextInningButton.tintColor = .gray400
        inningLabel.morphingEffect = .scale
        setUpPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scoreLabel.text = game?.scoreString
    }
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        showOptionsForGame()
    }
    
    @IBAction func scoreLabelPressed(_ sender: UITapGestureRecognizer) {
        guard var game = game, !game.isCompleted, hasEditRights else { return }
        game.opponentScore += 1
        core.fire(command: UpdateObject(game))
    }
    
    @IBAction func inningArrowPressed(_ sender: UIButton) {
        guard let game = game, hasEditRights else { return }
        let previousButtonWasPressed = sender == previousInningButton
        let newInning = previousButtonWasPressed ? game.inning - 1 : game.inning + 1
        updateInning(newInning)
    }
    
    @IBAction func outButtonPressed(_ sender: UIButton) {
        guard let index = outButtons.index(of: sender) else { return }
        let outs = core.state.gameState.outs
        if outs == 2 && index == 2 {
            core.fire(event: OutAdded())
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                self.core.fire(event: OutsReset())
                self.updateInning()
            })
        } else if index == outs {
            core.fire(event: OutAdded())
        } else {
            core.fire(event: OutSubtracted())
        }
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if let game = game {
            updateUI(with: game)
            updatePicker(game: game)
            if scoreLabel.text != "-" {
                scoreLabel.text = game.scoreString
            }
        }
        var playerNames = gamePlayers.map { $0.name }
        playerNames.append("⬅️")
        names = playerNames
        updateOuts(outs: state.gameState.outs)
        adapter.performUpdates(animated: true)
    }
    
    fileprivate func updateOuts(outs: Int) {
        for (index, button) in outButtons.enumerated() {
            button.isEnabled = index <= outs
            
            if index > outs {
                button.alpha = 0
            } else if index == outs {
                button.alpha = 0.4
            } else {
                button.alpha = 1
            }
        }
    }
    
}


extension GameViewController {
    
    fileprivate func updateUI(with game: Game) {
        if let team = core.state.teamState.currentTeam {
            awayTeamLabel.text = game.isHome ? game.opponent : team.name
            homeTeamLabel.text = game.isHome ? team.name : game.opponent
            navigationItem.rightBarButtonItem = hasEditRights ? settingsButton : nil
        }
        inningLabel.text = game.status
        previousInningButton.tintColor = game.inning == 1 ? .white : .gray400
        previousInningButton.isEnabled = game.inning > 1
        
    }
    
    fileprivate func updatePicker(game: Game) {
        guard let currentPlayer = core.state.gameState.currentPlayer,
            let index = game.lineupIds.index(of: currentPlayer.id),
            playerPickerView.selectedItem != index else { return }
        playerPickerView.selectItem(index, animated: true, notifySelection: true)
    }
    
    fileprivate func updateInning(_ inning: Int? = nil) {
        guard var updatedGame = game, hasEditRights else { return }
        let newInning = inning ?? updatedGame.inning + 1
        updatedGame.inning = newInning
        core.fire(command: UpdateObject(updatedGame))
        core.fire(event: OutsReset())
    }
    
    fileprivate func showOptionsForGame() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit Game ✏️", style: .default, handler: { _ in
            self.changeGameCompletion(isCompleted: false)
            self.presentGameEditVC()
        }))
        let emojiForStatus = game!.score > game!.opponentScore ? "😎" : "😞"
        
        let endGameAction = UIAlertAction(title: "End Game \(emojiForStatus)", style: .default, handler: { _ in
            self.changeGameCompletion(isCompleted: true)
        })
        if let game = game, !game.isCompleted {
            alert.addAction(endGameAction)
        }
        alert.addAction(UIAlertAction(title: "Delete game ☠️", style: .destructive, handler: { _ in
            self.presentConfirmationAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentAtBatCreation() {
        let newAtBatVC = AtBatCreationViewController.initializeFromStoryboard()
        customPresentViewController(customPresenter, viewController: newAtBatVC, animated: true, completion: nil)
    }
    
    func presentAtBatEdit(atBat: AtBat) {
        guard let game = game, !game.isCompleted else { return }
        let newAtBatVC = AtBatCreationViewController.initializeFromStoryboard()
        newAtBatVC.editingAtBat = atBat
        customPresentViewController(customPresenter, viewController: newAtBatVC, animated: true, completion: nil)
    }
    
    fileprivate func presentGameEditVC() {
        let gameCreationVC = GameCreationViewController.initializeFromStoryboard()
        gameCreationVC.editingGame = game
        let gameCreationNav = gameCreationVC.embededInNavigationController
        gameCreationVC.modalPresentationStyle = .overFullScreen
        present(gameCreationNav, animated: true, completion: nil)
    }
    
    fileprivate func changeGameCompletion(isCompleted: Bool) {
        guard var game = game, hasEditRights else { return }
        game.isCompleted = isCompleted
        core.fire(command: UpdateObject(game))
        
        if isCompleted {
            navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func presentConfirmationAlert() {
        let alert = Presentr.alertViewController(title: "Are you sure?", body: "This cannot be undone")
        alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            guard let game = self.game, self.hasEditRights else { return }
            self.core.fire(command: DeleteGame(game))
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}


extension GameViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects = [IGListDiffable]()
        for (index, atBat) in currentAtBats.enumerated() {
            objects.append(AtBatSection(atBat: atBat, order: currentAtBats.count - index))
        }
        if let currentUser = core.state.userState.currentUser, let team = core.state.teamState.currentTeam, currentUser.isOwnerOrManager(of: team), let game = game, !game.isCompleted {
            let newAtBatSection = NewAtBatSection()
            objects.insert(newAtBatSection, at: 0)
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case _ as NewAtBatSection:
            let newAtBatSectionController = NewAtBatSectionController()
            newAtBatSectionController.cellSelected = presentAtBatCreation
            return newAtBatSectionController
        case _ as AtBatSection:
            guard let game = game else { fatalError() }
            let canEdit = hasEditRights && !game.isCompleted
            let atBatSectionController = AtBatSectionController(canEdit: canEdit)
            atBatSectionController.didSelectAtBat = { [weak self] atBat in
                guard let weakSelf = self else { return }
                guard weakSelf.hasEditRights else { return }
                weakSelf.presentAtBatEdit(atBat: atBat)
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
        return names.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return names[item]
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        if item == gamePlayers.count {
            pickerView.selectItem(0, animated: true, notifySelection: true)
        } else {
            core.fire(event: Selected<Player>(gamePlayers[item]))
        }
    }
    
}
