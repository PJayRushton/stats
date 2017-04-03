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
                return [.manageTeams]
            }
        }
        
        var title: String? {
            switch self {
            case .teams:
                return "Manage Teams"
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
        
        registerCells()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version: \(version)"
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Fileprivate 

extension SettingsViewController {
    
    fileprivate func registerCells() {
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: BasicHeaderCell.reuseIdentifier)
        
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
        header.update(with: UIColor.gray100, text: title, alignment: .center)
        return header
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SettingsSection(rawValue: indexPath.section)!
        let theRow = section.rows[indexPath.row]
        
        switch theRow {
        case .manageTeams:
            let manageTeamsVC = ManageTeamsViewController.initializeFromStoryboard()
            navigationController?.pushViewController(manageTeamsVC, animated: true)
        case .switchTeam:
            break
        }
    }
    
}
