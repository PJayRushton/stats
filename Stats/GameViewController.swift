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
    var currentAtBats: [AtBat] {
        guard let player = currentPlayer else { return [] }
        return core.state.atBatState.atBats(for: player)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
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
