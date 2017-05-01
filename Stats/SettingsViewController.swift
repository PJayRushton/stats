//
//  SettingsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/1/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class SettingsViewController: Component, AutoStoryboardInitializable {
    
    enum SettingsSection: Int {
        case teams
        
        var rows: [SettingsRow] {
            switch self {
            case .teams:
                return [.manageTeams, .switchTeam]
            }
        }
        
        var title: String? {
            switch self {
            case .teams:
                return "Team Management"
            }
        }
        static let allValues = [SettingsSection.teams]
    }
    
    enum SettingsRow: Int {
        case manageTeams
        case switchTeam
        
        var title: String {
            switch self {
            case .manageTeams:
                return "Manage Teams"
            case .switchTeam:
                return "Switch Team"
            }
        }
        var detail: String? {
            switch self {
            case .manageTeams:
                return nil
            case .switchTeam:
                return App.core.state.teamState.currentTeam?.name
            }
        }
        
        var accessory: UITableViewCellAccessoryType {
            switch self {
            case .manageTeams, .switchTeam:
                return .disclosureIndicator
            }
        }
        
    }
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainNavBarColor
        navigationItem.leftBarButtonItem?.tintColor =  .white
        Appearance.setUp(navTextColor: .white)
        registerCells()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version: \(version)"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Appearance.setUp()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func update(with: AppState) {
        tableView.reloadData()
    }
    
}


// MARK: - Fileprivate 

extension SettingsViewController {
    
    fileprivate func registerCells() {
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
        
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
    }
    
}


// MARK: - TableView

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SettingsSection(rawValue: section)!
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SettingsSection(rawValue: indexPath.section)!
        let row = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        cell.update(withTitle: row.title, detail: row.detail, accessory: row.accessory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let theSection = SettingsSection(rawValue: section)!
        let header = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        guard let title = theSection.title else { return nil }
        header.update(with: title, backgroundColor: UIColor.gray100, alignment: .center)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = SettingsSection(rawValue: indexPath.section)!
        let theRow = section.rows[indexPath.row]
        
        switch theRow {
        case .manageTeams:
            let teamManagerVC = TeamListViewController.initializeFromStoryboard()
            teamManagerVC.isDismissable = false
            teamManagerVC.isSwitcher = false
            navigationController?.pushViewController(teamManagerVC, animated: true)
        case .switchTeam:
            let teamSwitcherVC = TeamListViewController.initializeFromStoryboard()
            teamSwitcherVC.isDismissable = false
            teamSwitcherVC.isSwitcher = true
            navigationController?.pushViewController(teamSwitcherVC, animated: true)
        }
    }
    
}
