//
//  RosterViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit

class RosterViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    fileprivate var allPlayers = [Player]()
    fileprivate var regularPlayers = [Player]()
    fileprivate var subs = [Player]()
    
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    
    fileprivate var hasSubs: Bool {
        return !subs.isEmpty
    }
    
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPlayers()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        feedbackGenerator.prepare()
    }

}


extension RosterViewController {
    
    fileprivate func setUpPlayers() {
        guard let currentTeam = currentTeam else { return }
        let teamPlayers = core.state.playerState.players(for: currentTeam)
        allPlayers = teamPlayers
        regularPlayers = teamPlayers.filter { !$0.isSub }
        subs = teamPlayers.filter { $0.isSub }
    }
    
    func didSelectPlayer(_ player: Player) {
        print("did Select player: \(player)")
    }
    
    func upButtonPressed(for player: Player) {
        if let index = regularPlayers.index(of: player) {
            regularPlayers.remove(at: index)
            regularPlayers.insert(player, at: index - 1)
            adapter.performUpdates(animated: true)
        }
    }
    
}

extension RosterViewController {
    
    enum RosterSection: Int {
        case regular
        case sub
        
        static let allValues = [RosterSection.regular, .sub]
        
        var sectionTitle: String {
            switch self {
            case .regular:
                return "Regulars"
            case .sub:
                return "Subs"
            }
        }
        
    }
    
}

extension RosterViewController: IGListAdapterDataSource {
    
    fileprivate func players(forSection section: RosterSection) -> [Player] {
        switch section {
        case .regular:
            return regularPlayers
        case .sub:
            return subs
        }
    }
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return regularPlayers.map(PlayerSection.init)
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        let sectionController = PlayerSectionController()
        sectionController.didSelectPlayer = didSelectPlayer
        sectionController.didUpPlayer = upButtonPressed
        return PlayerSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}
