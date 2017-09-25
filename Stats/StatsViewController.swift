//
//  StatsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import BetterSegmentedControl
import QuickLook

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
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var filterBarButton: UIBarButtonItem!
    
    fileprivate let qlController = QLPreviewController()
    fileprivate var csvPaths = [URL]()
    fileprivate var currentViewType: StatsViewType {
        return core.state.statState.currentViewType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.setUp(with: StatsViewType.allValues.map { $0.title }, indicatorColor: UIColor.mainAppColor)
        qlController.dataSource = self
        
        if core.state.statState.currentCSVPath == nil {
            core.fire(command: SaveCurrentCSV())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor.mainNavBarColor
        
        if core.state.statState.currentGame == nil {
            core.fire(command: MarkTeamStatsViewed())
        }
    }
    
    @IBAction func viewTypeChanged(_ sender: BetterSegmentedControl) {
        guard let newViewType = StatsViewType(rawValue: Int(sender.index)), newViewType != currentViewType else { return }
        core.fire(event: Updated<StatsViewType>(newViewType))
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let filterVC = StatFilterViewController.initializeFromStoryboard().embededInNavigationController
        filterVC.modalPresentationStyle = .popover
        present(filterVC, animated: true, completion: nil)
    }
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        showExportPreview()
    }
    
    override func update(with state: AppState) {
        topLabel.isHidden = false
        if let currentStatGame = state.statState.currentGame {
            topLabel.text = "St@ts for game vs. \(currentStatGame.opponent)"
        } else if let season = state.seasonState.currentSeason {
            topLabel.text = "St@ts for \(season.name)"
        } else {
            topLabel.isHidden = true
        }
        csvPaths = Array(state.statState.statPaths.values)
        try? segmentedControl.setIndex(UInt(state.statState.currentViewType.rawValue))
        let atBatsAreEmpty = state.atBatState.atBats.isEmpty
        segmentedControl.isHidden = atBatsAreEmpty
        navigationItem.rightBarButtonItem = state.statState.currentGame == nil ? filterBarButton : nil
    }
    
}


// MARK: - Internal

extension StatsViewController {
    
    fileprivate func showExportPreview() {
        navigationController?.pushViewController(qlController, animated: true)
    }
    
}


// MARK: - QLPreview

extension StatsViewController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return csvPaths.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return csvPaths[index] as QLPreviewItem
    }
    
}
