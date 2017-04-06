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
        
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        registerCells()
        setUpSegmentedControl()
        
        if !dismissable {
            navigationItem.leftBarButtonItem = nil
        }
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
    
    fileprivate func currentTeams() -> [Team] {
        let type = TeamOwnershipType(rawValue: tab)!
        return core.state.teamState.currentUserTeams(forType: type)
    }
    
    fileprivate func registerCells() {
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
    }
    
    fileprivate func setUpSegmentedControl() {
        segmentedControl.titles = TeamOwnershipType.allValues.map { $0.sectionTitle }
        segmentedControl.titleFont = FontType.lemonMilk.font(withSize: 14)
        segmentedControl.selectedTitleFont = FontType.lemonMilk.font(withSize: 16)
        segmentedControl.indicatorViewBackgroundColor = .secondaryAppColor
    }

    fileprivate func launchTeamCreation() {
        let type = TeamOwnershipType(rawValue: tab)!
        switch type {
        case .owned:
            let teamCreationVC = TeamCreationViewController.initializeFromStoryboard().embededInNavigationController
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
        return currentTeams().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        let team = currentTeams()[indexPath.row]
        cell.update(with: team, accessory: .disclosureIndicator, fontSize: 18)
        
        return cell
    }
    
}

extension ManageTeamsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let creationVC = TeamCreationViewController.initializeFromStoryboard()
        creationVC.editingTeam = currentTeams()[indexPath.row]
        creationVC.isDismissable = false
        navigationController?.pushViewController(creationVC, animated: true)
    }
    
}
