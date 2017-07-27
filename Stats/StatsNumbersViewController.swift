//
//  StatsNumbersViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
//import IGListKit

class StatsNumbersViewController: Component, AutoStoryboardInitializable {

    @IBOutlet weak var collectionView: UICollectionView!

    var layout = StatsLayout()
    var statDict = [Player: [Stat]]()
    var players = [Player]()

    fileprivate var verticalSizeClass: UIUserInterfaceSizeClass = UIUserInterfaceSizeClass.unspecified {
        didSet {
            guard verticalSizeClass != oldValue else { return }
            layout.verticalSizeClass = verticalSizeClass
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
    }
    
    override func update(with state: AppState) {
        let currentPlayers = state.playerState.currentStatPlayers
        players = currentPlayers
        
        var statDict = [Player: [Stat]]()
        currentPlayers.forEach { player in
            statDict[player] = state.stats(for: player)
        }
        self.statDict = statDict
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        verticalSizeClass = traitCollection.verticalSizeClass
    }
    
}

extension StatsNumbersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func stats(forSection section: Int) -> [Stat] {
        let playerForSection = players[section]
        return statDict[playerForSection] ?? []
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StatType.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatCell.reuseIdentifier, for: indexPath) as! StatCell
        let playerStats = stats(forSection: indexPath.section)
        cell.update(with: playerStats[indexPath.row], place: nil) // FIXME:
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else { fatalError(); return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StatsHeaderCell.reuseIdentifier, for: indexPath) as! StatsHeaderCell
        header.update(with: "\(indexPath)", backgroundColor: .white)
        
        return header
    }
    
    func setUpLayout() {
        let statCellNib = UINib(nibName: StatCell.reuseIdentifier, bundle: nil)
        collectionView.register(statCellNib, forCellWithReuseIdentifier: StatCell.reuseIdentifier)
        let headerNib = UINib(nibName: StatsHeaderCell.reuseIdentifier, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: StatsHeaderCell.reuseIdentifier)
        collectionView.collectionViewLayout = layout
    }
    
}

//extension StatsNumbersViewController: ListAdapterDataSource {
//    
//    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        let currentAtBats = core.state.currentAtBats
//        var stats = core.state.allStats(ofType: currentStatType, from: currentAtBats)
//        stats.sort(by: core.state.statState.sortType.sort)
//        return stats.map { StatSection(stat: $0) }
//    }
//    
//    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        return StatSectionController()
//    }
//    
//    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        return nil
//    }
//    
//}

//extension StatsNumbersViewController: AKPickerViewDelegate, AKPickerViewDataSource {
//    
//    func setUpPickerView() {
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        pickerView.font = FontType.lemonMilk.font(withSize: 15)
//        pickerView.highlightedFont = FontType.lemonMilk.font(withSize: 16)
//        pickerView.highlightedTextColor = UIColor.mainAppColor
//        pickerView.interitemSpacing = 55
//        pickerView.pickerViewStyle = .flat
//    }
//    
//    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
//        return StatType.allValues.count + 1
//    }
//    
//    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
//        return item == StatType.allValues.count ? "⬅️" : StatType.allValues[item].abbreviation
//    }
//    
//    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
//        if item == StatType.allValues.count {
//            pickerView.selectItem(0, animated: true, notifySelection: true)
//        } else {
//            let selectedStat = StatType.allValues[item]
//            core.fire(event: Updated<StatType>(selectedStat))
//        }
//    }
//    
//}
