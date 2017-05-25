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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var emptyView: UIView!

    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
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

extension StatsTrophiesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let allTrophies = Trophy.allValues
        guard let currentTeam = core.state.teamState.currentTeam else { return [] }
        var teamAtBats = core.state.atBatState.atBats(for: currentTeam)
        
        if core.state.statState.includeSubs == false {
            teamAtBats = teamAtBats.filter({ atBat -> Bool in
                guard let player = atBat.playerId.statePlayer else { return false }
                return !player.isSub
            })
        }
        var trophySections = [ListDiffable]()
        
        allTrophies.forEach { trophy in
            let trophyStats = trophy.statType.allStats(with: teamAtBats).sorted(by: { $0.value > $1.value })
            var winnerStat: Stat?
            var secondStat: Stat?
            
            if trophy == .worseBattingAverage {
                winnerStat = trophyStats.last
                if trophyStats.count > 1 {
                    secondStat = trophyStats[trophyStats.count - 2]
                    
                    if currentTeam.isCoed {
                        let otherGender: Gender = winnerStat?.player.gender == .male ? .female : .male
                        let otherGenderStats = trophyStats.filter { $0.player.gender == otherGender }
                        if let otherGenderStat = otherGenderStats.last {
                            secondStat = otherGenderStat
                        }
                    }
                }
            } else {
                winnerStat = trophyStats.first
                if trophyStats.count > 1 {
                    secondStat = trophyStats[1]
                    if currentTeam.isCoed {
                        let otherGender: Gender = winnerStat?.player.gender == .male ? .female : .male
                        let otherGenderStats = trophyStats.filter { $0.player.gender == otherGender }
                        if let otherGenderStat = otherGenderStats.first {
                            secondStat = otherGenderStat
                        }
                    }
                }
                
            }
            guard let winner = winnerStat, winner.value > 0 else { return }
            var firstLoser: Stat?
            
            if let secondPlaceStat = secondStat, secondPlaceStat.value > 0, secondPlaceStat.statType == winner.statType {
                firstLoser = secondPlaceStat
            }
            let trophySection = TrophySection(trophy: trophy, firstStat: winner, secondStat: firstLoser)
            trophySections.append(trophySection)
        }
        return trophySections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return TrophySectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyView
    }
    
}
