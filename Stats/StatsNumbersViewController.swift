//
//  StatsNumbersViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit
import SpreadsheetView

class StatsNumbersViewController: Component, AutoStoryboardInitializable {

    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    fileprivate let selectedBackground = UIColor.mainAppColor.withAlphaComponent(0.2)

    fileprivate var allStats: [Stat] {
        return core.state.statState.currentStats?.stats.values.flatMap { $0 } ?? []
    }
    
    fileprivate var currentPlayers = [Player]() {
        didSet {
            spreadsheetView.reloadData()
        }
    }
    
    fileprivate var sortSection = 0 {
        didSet {
            updatePlayerOrder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(StatCell.self, forCellWithReuseIdentifier: StatCell.reuseIdentifier)
    }
    
    override func update(with state: AppState) {
        currentPlayers = state.playerState.currentStatPlayers
        updatePlayerOrder()
    }
    
}


// MARK: - Internal

extension StatsNumbersViewController {
    
    fileprivate func updatePlayerOrder() {
        if sortSection == 0 {
            currentPlayers.sort()
            return
        }
        let selectedStatType = statType(for: sortSection)
        var selectedStats = stats(ofType: selectedStatType)
        selectedStats.sort(by: >)
        let idOrder = selectedStats.map { $0.playerId }
        currentPlayers.sort { idOrder.index(of: $0.id)! < idOrder.index(of: $1.id)! }
    }
    
    fileprivate func stats(ofType type: StatType) -> [Stat] {
        return allStats.filter { $0.type == type }
    }
    
}


// MARK: - SpreadsheetView

extension StatsNumbersViewController: SpreadsheetViewDataSource {
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return StatType.allValues.count + 1
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return currentPlayers.count + 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return column == 0 ? 130 : 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 60
    }
    
    func statType(for section: Int) -> StatType {
        return StatType.allValues[section - 1]
    }
    
    func player(forRow row: Int) -> Player {
        return currentPlayers[row - 1]
    }
    
    func stat(at indexPath: IndexPath) -> Stat? {
        guard indexPath.section != 0 || indexPath.row != 0 else { fatalError() }
        let statTypeAtSection = statType(for: indexPath.section)
        let stats = self.stats(ofType: statTypeAtSection)
        let playerForRow = player(forRow: indexPath.row)
        return stats.first(where: { $0.player == playerForRow })
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        var title = ""
        let alignment = NSTextAlignment.center
        let fontSize: CGFloat = indexPath.section == 0 || indexPath.row == 0 ? 20 : 17
        
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: StatCell.reuseIdentifier, for: indexPath) as! StatCell
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            title = "Player"
            cell.backgroundColor = sortSection == 0 ? selectedBackground : .white
        case (0, _):
            title = player(forRow: indexPath.row).displayName
            cell.backgroundColor = .white
        case (_, 0):
            title = statType(for: indexPath.section).abbreviation
            cell.backgroundColor = sortSection == indexPath.section ? selectedBackground : .white
        default:
            title = stat(at: indexPath)?.displayString ?? ""
            cell.backgroundColor = .white
        }
        cell.update(with: title, alignment: alignment, fontSize: fontSize)
        
        return cell
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

}

extension StatsNumbersViewController: SpreadsheetViewDelegate {
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        sortSection = indexPath.section
    }
    
}
