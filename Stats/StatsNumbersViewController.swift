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
        let players = core.state.atBatState.allAtBats.flatMap { $0.playerId.statePlayer }
        var allSections = [IGListDiffable]()
        var allStats = [Stat]()
        
        players.forEach { player in
            let atBats = core.state.atBatState.atBats(for: player)
            let playerStat = Stat(displayName: player.name, statType: currentStatType, value: currentStatType.statValue(with: atBats))
            allStats.append(playerStat)
        }
        allStats.sort(by: { $0.value > $1.value })
        let allStatValues = Set(allStats.map { $0.value }).sorted(by: { $0 > $1 })
        
        allStats.forEach { stat in
            var place: Place?
            if let index = allStatValues.index(of: stat.value), let statPlace = Place(rawValue: index) {
                place = statPlace
            }
            let section = StatSection(stat: stat, place: nil)
            allSections.append(section)
        }
        return allSections
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
