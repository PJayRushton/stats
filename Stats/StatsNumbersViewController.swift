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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: AKPickerView!
    
    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
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

extension StatsNumbersViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let currentAtBats = core.state.currentAtBats
        var stats = core.state.allStats(ofType: currentStatType, from: currentAtBats)
        stats.sort(by: core.state.statState.sortType.sort)
        return stats.map { StatSection(stat: $0) }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return StatSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
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
