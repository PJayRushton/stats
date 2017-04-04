//
//  TeamSwitcherViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class TeamSwitcherViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedTeam: Team? {
        return core.state.teamState.currentTeam
    }
    
    var dismissable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !dismissable {
            navigationItem.rightBarButtonItem = nil
        }
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
        
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TeamSwitcherViewController {
    
    func teams(for section: Int) -> [Team] {
        let type = TeamOwnershipType(rawValue: section)!
        return core.state.teamState.currentUserTeams(forType: type)
    }
    
}


extension TeamSwitcherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        let team = teams(for: indexPath.section)[indexPath.row]
        cell.update(with: team, isSelected: team == selectedTeam)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let title = TeamOwnershipType(rawValue: section)!.sectionTitle
        header.update(with: UIColor.gray100, text: title, alignment: .center)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension TeamSwitcherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = teams(for: indexPath.section)[indexPath.row]
        core.fire(event: Selected<Team>(selectedTeam))
        if dismissable {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
