//
//  StatsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import BetterSegmentedControl

enum StatsViewType: Int {
    case trophies
    case stats
//    case compare
    
    var title: String {
        switch self {
        case .trophies:
            return NSLocalizedString("Trophies", comment: "Awards given to players")
        case .stats:
            return NSLocalizedString("Stats", comment: "Section that displays the raw stat numbers")
        }
    }
    static let allValues = [StatsViewType.trophies, .stats]
}

class StatsViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var currentViewType: StatsViewType {
        return core.state.statState.currentViewType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.setUp(with: StatsViewType.allValues.map { $0.title }, indicatorColor: UIColor.mainAppColor)
    }
    
    @IBAction func viewTypeChanged(_ sender: BetterSegmentedControl) {
        guard let newViewType = StatsViewType(rawValue: Int(sender.index)) else { return }
        core.fire(event: Updated<StatsViewType>(newViewType))
    }
    
    override func update(with state: AppState) {
        navigationController?.navigationBar.barTintColor = state.currentMenuItem?.backgroundColor
        try? segmentedControl.setIndex(UInt(state.statState.currentViewType.rawValue))
    }
    
}
