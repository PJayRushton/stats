//
//  StatFilterViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import AIFlatSwitch

class StatFilterViewController: UITableViewController, AutoStoryboardInitializable {
    
    @IBOutlet var headerViews: [UIView]!
    @IBOutlet weak var subSwitch: AIFlatSwitch!
    @IBOutlet weak var seasonLabel: UILabel!
    
    var core = App.core
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subSwitch.isSelected = core.state.statState.includeSubs
        seasonLabel.text = core.state.seasonState.currentSeason?.name
        headerViews.forEach { view in
            view.backgroundColor = .secondaryAppColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.mainNavBarColor
    }
    
    @IBAction func subSwitchFlipped(_ sender: AIFlatSwitch) {
        core.fire(event: SubFilterUpdated(includeSubs: sender.isSelected))
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension StatFilterViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (_, 0):
            subSwitchFlipped(subSwitch)
        case (_, 1):
            pushSeasonPicker()
        default:
            break
        }
    }
    
    fileprivate func pushSeasonPicker() {
        let seasonsVC = SeasonsViewController.initializeFromStoryboard()
        navigationController?.pushViewController(seasonsVC, animated: true)
    }
    
}
