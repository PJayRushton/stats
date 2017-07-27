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
    
    var allStats = [StatType: [Stat]]() {
        didSet {
            spreadsheetView.reloadData()
        }
    }
    var currentPlayers = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(StatCell.self, forCellWithReuseIdentifier: StatCell.reuseIdentifier)
    }
    
    override func update(with state: AppState) {
        currentPlayers = state.playerState.currentStatPlayers
        StatType.allValues.forEach { statType in
            let stats = state.allStats(ofType: statType, from: state.currentAtBats)
            allStats[statType] = stats
        }
    }
    
}

extension StatsNumbersViewController {
    
}

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
    
    func stat(at indexPath: IndexPath) -> Stat {
        guard indexPath.section != 0 || indexPath.row != 0 else { fatalError() }
        let statTypeAtSection = statType(for: indexPath.section)
        guard let stats = allStats[statTypeAtSection] else { fatalError() }
        let playerForRow = player(forRow: indexPath.row)
        return stats.first(where: { $0.player == playerForRow })!
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        var title = ""
        let alignment = NSTextAlignment.center
        let fontSize: CGFloat = indexPath.section == 0 || indexPath.row == 0 ? 20 : 17
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            title = "Player"
        case (0, _):
            title = player(forRow: indexPath.row).displayName
        case (_, 0):
            title = statType(for: indexPath.section).abbreviation
        default:
            title = stat(at: indexPath).displayString
        }
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: StatCell.reuseIdentifier, for: indexPath) as! StatCell
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
    
    
}

