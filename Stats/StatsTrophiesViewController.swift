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

    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

}

extension StatsTrophiesViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        let allTrophies = Trophy.allValues
        let allAtBats = Array(core.state.atBatState.allAtBats)
        
        var trophySections = [IGListDiffable]()
        
        allTrophies.forEach { trophy in
            let trophyStats = trophy.statType.allStats(with: allAtBats).sorted(by: { $0.value > $1.value })
            var winnerStat: Stat?
            var secondStat: Stat?
            
            if trophy == .worseBattingAverage {
                winnerStat = trophyStats.last
                secondStat = trophyStats[trophyStats.count - 2]
            } else {
                winnerStat = trophyStats.first
                secondStat = trophyStats[1]
            }
            guard let winner = winnerStat, winner.value > 0 else { return }
            let firstLoser: Stat? = secondStat != nil && secondStat!.value > 0 ? secondStat! : nil
            trophySections.append(TrophySection(trophy: trophy, firstStat: winner, secondStat: firstLoser))
        }
        return trophySections
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return TrophySectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}
