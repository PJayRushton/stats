//
//  StatsNumbersViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit

class StatsNumbersViewController: Component, AutoStoryboardInitializable {

    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet weak var pickerView: AKPickerView!
    
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var currentStatType: StatType {
        return core.state.statState.currentStatType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickerView()
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func update(with state: AppState) {
        adapter.performUpdates(animated: true)
    }
}

extension StatsNumbersViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        guard let currentTeam = core.state.teamState.currentTeam else { return [] }
        var allAtBats = core.state.atBatState.atBats(for: currentTeam)
        
        if core.state.statState.includeSubs == false {
            allAtBats = allAtBats.filter({ atBat -> Bool in
                guard let player = atBat.playerId.statePlayer else { return false }
                return !player.isSub
            })
        }
        
        let players = allAtBats.flatMap { $0.playerId.statePlayer }
        var allStats = [Stat]()
        
        players.forEach { player in
            let atBats = core.state.atBatState.atBats(for: player)
            allStats.append(player.stat(ofType: currentStatType, from: atBats))
        }
        dump(allStats.map { $0.player.name })
        let sortedStats = allStats.sorted(by: core.state.statState.sortType.sort)
        dump(sortedStats.map { $0.player.name })
        return sortedStats.map { StatSection(stat: $0) }
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return StatSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}

extension StatsNumbersViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.font = FontType.lemonMilk.font(withSize: 15)
        pickerView.highlightedFont = FontType.lemonMilk.font(withSize: 16)
        pickerView.highlightedTextColor = UIColor.mainAppColor
        pickerView.interitemSpacing = 55
        pickerView.pickerViewStyle = .flat
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return StatType.allValues.count + 1
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return item == StatType.allValues.count ? "⬅️" : StatType.allValues[item].abbreviation
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        if item == StatType.allValues.count {
            pickerView.selectItem(0, animated: true, notifySelection: true)
        } else {
            let selectedStat = StatType.allValues[item]
            core.fire(event: Updated<StatType>(selectedStat))
        }
    }
    
}
