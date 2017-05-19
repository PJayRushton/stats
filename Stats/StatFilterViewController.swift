//
//  StatFilterViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import AIFlatSwitch
import BetterSegmentedControl

enum SortType: Int {
    case best
    case worst
    case name
    
    static let allValues = [SortType.best, .worst, .name]
    
    var title: String {
        switch self {
        case .best:
            return "Best"
        case .worst:
            return "Worst"
        case .name:
            return "Name"
        }
    }
    
    var sort: ((Stat, Stat) -> Bool) {
        switch self {
        case .best:
            return (>)
        case .worst:
            return (<)
        case .name:
            return { $0.player.name < $1.player.name }
        }
    }
    
}

class StatFilterViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var subSwitch: AIFlatSwitch!
    @IBOutlet weak var sortSegControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortTitles = SortType.allValues.map { $0.title }
        sortSegControl.setUp(with: sortTitles, indicatorColor: UIColor.secondaryAppColor, fontSize: 18)
        subSwitch.isSelected = core.state.statState.includeSubs
        try? sortSegControl.setIndex(UInt(core.state.statState.sortType.rawValue))
    }
    
    @IBAction func subSwitchFlipped(_ sender: AIFlatSwitch) {
        core.fire(event: SubFilterUpdated(includeSubs: sender.isSelected))
    }
    
    @IBAction func sortTypeChanged(_ sender: BetterSegmentedControl) {
        guard let selectedSortType = SortType(rawValue: Int(sender.index)) else { return }
        core.fire(event: Updated<SortType>(selectedSortType))
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func update(with state: AppState) {
        navigationController?.navigationBar.barTintColor = UIColor.mainAppColor
    }
    
}

