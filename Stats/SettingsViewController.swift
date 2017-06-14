//
//  SettingsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/1/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class SettingsViewController: Component, AutoStoryboardInitializable {
    
    // MARK: - Types

    enum SettingsSection: Int {
        case profile
        case teams
        
        var rows: [SettingsRow] {
            switch self {
            case .profile:
                return [.username, .email]
            case .teams:
                return [.manageTeams, .switchTeam, .seasons]
            }
        }
        
        var title: String? {
            switch self {
            case .profile:
                return NSLocalizedString("Profile", comment: "")
            case .teams:
                return NSLocalizedString("Team Management", comment: "")
            }
        }
        static let allValues = [SettingsSection.profile, .teams]
    }
    
    enum SettingsRow: Int {
        case username
        case email
        case manageTeams
        case switchTeam
        case seasons
        
        var title: String {
            switch self {
            case .username:
                return NSLocalizedString("Username", comment: "")
            case .email:
                return NSLocalizedString("Email", comment: "")
            case .manageTeams:
                return NSLocalizedString("Manage Teams", comment: "")
            case .switchTeam:
                return NSLocalizedString("Switch Team", comment: "")
            case .seasons:
                return NSLocalizedString("Manage Seasons", comment: "")
            }
        }
        var accessory: UITableViewCellAccessoryType {
            switch self {
            case .username, .email:
                return .none
            case .manageTeams, .switchTeam, .seasons:
                return .disclosureIndicator
            }
        }
        
    }

    
    // MARK: - IBActions

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Constants

    fileprivate let settingsCellId = "SettingsCell"
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = UIColor.mainNavBarColor
        navigationItem.leftBarButtonItem?.tintColor =  .white
        Appearance.setUp(navTextColor: .white)
        tableView.sectionHeaderHeight = 32
        registerCells()
        
        var versionString = ""
        if let version = Bundle.main.releaseVersionNumber {
            versionString = "Version: \(version)"
        }
        if let buildString = Bundle.main.buildVersionNumber {
            versionString += " (\(buildString))"
        }
        versionLabel.text = versionString
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Appearance.setUp()
    }

    
    // MARK: - IBActions
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Subscriber
    
    override func update(with: AppState) {
        tableView.reloadData()
    }
    
}


// MARK: - Fileprivate 

extension SettingsViewController {
    
    fileprivate func registerCells() {
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
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
        let theRow = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId, for: indexPath)
        cell.textLabel?.text = theRow.title
        cell.accessoryType = theRow.accessory
        cell.detailTextLabel?.text = detail(for: theRow)
        
        return cell
    }
    
    fileprivate func detail(for row: SettingsRow) -> String? {
        switch row {
        case .username:
            return core.state.userState.currentUser?.username
        case .email:
            return core.state.userState.currentUser?.email
        case .manageTeams:
            return nil
        case .switchTeam:
            return core.state.teamState.currentTeam?.name
        case .seasons:
            return core.state.teamState.currentTeam?.currentSeason?.name
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let theSection = SettingsSection(rawValue: section)!
        let header = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        guard let title = theSection.title else { return nil }
        header.update(with: title)
        
        return header
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = SettingsSection(rawValue: indexPath.section)!
        let theRow = section.rows[indexPath.row]
        
        switch theRow {
        case .username, .email:
        return // FIXME:
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
        case .seasons:
            let seasonsVC = SeasonsViewController.initializeFromStoryboard()
            seasonsVC.isModal = false
            navigationController?.pushViewController(seasonsVC, animated: true)
        }
    }
    
}
