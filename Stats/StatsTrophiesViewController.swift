//
//  StatsTrophiesViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit

class StatsTrophiesViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet var emptyView: UIView!

    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func update(with state: AppState) {
        adapter.performUpdates(animated: true)
    }
    
    @IBAction func emptyStateButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension StatsTrophiesViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        let allTrophies = Trophy.allValues
        guard let currentTeam = core.state.teamState.currentTeam else { return [] }
        var teamAtBats = core.state.atBatState.atBats(for: currentTeam)
        
        if core.state.statState.includeSubs == false {
            teamAtBats = teamAtBats.filter({ atBat -> Bool in
                guard let player = atBat.playerId.statePlayer else { return false }
                return !player.isSub
            })
        }
        var trophySections = [IGListDiffable]()
        
        allTrophies.forEach { trophy in
            let trophyStats = trophy.statType.allStats(with: teamAtBats).sorted(by: { $0.value > $1.value })
            var winnerStat: Stat?
            var secondStat: Stat?
            
            if trophy == .worseBattingAverage {
                winnerStat = trophyStats.last
                if trophyStats.count > 1 {
                    secondStat = trophyStats[trophyStats.count - 2]
                }
            } else {
                winnerStat = trophyStats.first
                if trophyStats.count > 1 {
                    secondStat = trophyStats[1]
                }
            }
            guard let winner = winnerStat, winner.value > 0 else { return }
            var firstLoser: Stat?
            
            if let secondPlaceStat = secondStat, secondPlaceStat.value > 0, secondPlaceStat.statType == winner.statType {
                firstLoser = secondPlaceStat
            }
            
            trophySections.append(TrophySection(trophy: trophy, firstStat: winner, secondStat: firstLoser))
        }
        return trophySections
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return TrophySectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyView
    }
    
}
