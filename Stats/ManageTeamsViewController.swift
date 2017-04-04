//
//  ManageTeamsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class ManageTeamsViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!

    var dismissable = true
    var tab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !dismissable {
            navigationItem.leftBarButtonItem = nil
        }
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
        
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        segmentedControl.titles = TeamOwnershipType.allValues.map { $0.sectionTitle }
        segmentedControl.titleFont = FontType.lemonMilk.font(withSize: 14)
        segmentedControl.selectedTitleFont = FontType.lemonMilk.font(withSize: 16)
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        launchTeamCreation()
    }

    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlChanged(_ sender: BetterSegmentedControl) {
        tab = Int(sender.index)
        tableView.reloadData()
    }
    
    override func update(with: AppState) {
        tableView.reloadData()
    }
    
}

extension ManageTeamsViewController {
    
    var currentTeams: [Team] {
        let type = TeamOwnershipType(rawValue: tab)!
        return core.state.teamState.currentUserTeams(forType: type)
    }

    fileprivate func launchTeamCreation() {
        let type = TeamOwnershipType(rawValue: tab)!
        switch type {
        case .owned:
            let teamCreationVC = CreateTeamViewController.initializeFromStoryboard().embededInNavigationController
            present(teamCreationVC, animated: true, completion: nil)
        case .managed:
            break
        case .fan:
            break
        }
    }
    
}


extension ManageTeamsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        let team = currentTeams[indexPath.row]
        cell.update(with: team, accessory: .disclosureIndicator)
        
        return cell
    }
    
}
