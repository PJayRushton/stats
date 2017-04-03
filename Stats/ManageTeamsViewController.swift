//
//  ManageTeamsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class ManageTeamsViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
    }

    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ManageTeamsViewController: UITableViewDataSource {
    
    func teams(for section: Int) -> [Team] {
        let type = TeamOwnershipType(rawValue: section)!
        return core.state.teamState.currentUserTeams(forType: type)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TeamOwnershipType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        let team = teams(for: indexPath.section)[indexPath.row]
        cell.update(with: team)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let type = TeamOwnershipType(rawValue: section)!
        return type.sectionTitle
    }
    
}

extension ManageTeamsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
