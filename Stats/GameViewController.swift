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
        return core.state.playerState.allPlayers.filter { game.lineupIds.contains($0.id) }
    }
    var currentAtBats: [AtBat] {
        guard let player = currentPlayer else { return [] }
        return core.state.atBatState.atBats(for: player)
    }
    
    var game: Game? {
        return core.state.gameState.currentGame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        guard let game = game else { return }
        let currentTeam = core.state.teamState.currentTeam
        awayTeamLabel.text = game.isHome ? game.opponent : currentTeam?.name
        homeTeamLabel.text = game.isHome ? currentTeam?.name : game.opponent
        scoreLabel.text = game.scoreString
        inningLabel.text = game.status
        playerPickerView.delegate = self
        playerPickerView.dataSource = self
        playerPickerView.font = FontType.lemonMilk.font(withSize: 12)
        playerPickerView.highlightedFont = FontType.lemonMilk.font(withSize: 12)
        playerPickerView.interitemSpacing = 24
        playerPickerView.pickerViewStyle = .flat
    }
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        print("You tapped settings. YAY!")
    }
    
    func presentAtBatCreation() {
        
    }
    
    func presentAtBatEdit() {
        
    }
    
    override func update(with state: AppState) {
        adapter.performUpdates(animated: true)
    }
    
}

extension GameViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects: [IGListDiffable] = currentAtBats.map { AtBatSection(atBat: $0) }
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
            atBatSectionController.didSelectAtBat = presentAtBatEdit
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
