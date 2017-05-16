//
//  TeamListViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr

class TeamListViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isSwitcher = false
    var isDismissable = true
    
    fileprivate var plusBarButton: UIBarButtonItem?
    fileprivate var xBarButton: UIBarButtonItem?
    fileprivate var currentTypes = [TeamOwnershipType]()
    
    fileprivate var selectedTeam: Team? {
        return core.state.teamState.currentTeam
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .mainAppColor
        plusBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plusBar"), style: .plain, target: self, action: #selector(showAddTeamOptionsAlert))
        xBarButton = isDismissable ? UIBarButtonItem(image: #imageLiteral(resourceName: "xBar"), style: .plain, target: self, action: #selector(close)) : nil
        navigationItem.rightBarButtonItem = isSwitcher || isDismissable ? xBarButton : plusBarButton
        
        registerCells()
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        currentTypes = TeamOwnershipType.allValues.filter { !core.state.teamState.currentUserTeams(forType: $0).isEmpty }
        tableView.reloadData()
    }
    
}

// MARK: - Internal

extension TeamListViewController {
    
    fileprivate func registerCells() {
        let nib = UINib(nibName: BasicCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
    }
    
    fileprivate func teams(for section: Int) -> [Team] {
        let type = currentTypes[section]
        return core.state.teamState.currentUserTeams(forType: type)
    }
    
    func showAddTeamOptionsAlert() {
        let alert = Presentr.alertViewController(title: "New Team", body: "What would you like to do?")
        alert.addAction(AlertAction(title: "Create a team", style: .default, handler: { 
            self.dismiss(animated: true, completion: { 
                self.pushTeamCreation()
            })
        }))
        alert.addAction(AlertAction(title: "Add a team", style: .default, handler: { 
            self.dismiss(animated: true, completion: {
                self.presentAddTeam()
            })
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    fileprivate func pushTeamCreation(editingTeam team: Team? = nil) {
        let teamCreationVC = TeamCreationViewController.initializeFromStoryboard()
        teamCreationVC.isDismissable = false
        teamCreationVC.editingTeam = team
        navigationController?.pushViewController(teamCreationVC, animated: true)
    }
    
    fileprivate func presentAddTeam() {
        let addTeamVC = AddTeamViewController.initializeFromStoryboard().embededInNavigationController
        present(addTeamVC, animated: true, completion: nil)
    }
    
    fileprivate func presentOptionsForNonOwner(of team: Team) {
        let alert = UIAlertController(title: "\(team.name)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave Team", style: .destructive, handler: { _ in
            self.removeTeam(team)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func removeTeam(_ team: Team) {
        guard var currentUser = core.state.userState.currentUser else { return }
        currentUser.managedTeamIds.remove(team.id)
        currentUser.fanTeamIds.remove(team.id)
        core.fire(command: UpdateObject(currentUser))
    }
    
}


extension TeamListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier) as! BasicCell
        let team = teams(for: indexPath.section)[indexPath.row]
        let accessory = isSwitcher ? UITableViewCellAccessoryType.none : .disclosureIndicator
        cell.update(with: team, isSelected: team == selectedTeam && isSwitcher, accessory: accessory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let title = currentTypes[section].sectionTitle
        header.update(with:title, backgroundColor: .flatCoffee, alignment: .center)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension TeamListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = teams(for: indexPath.section)[indexPath.row]
        
        if isSwitcher {
            core.fire(command: TouchObject(selectedTeam))
            core.fire(event: Selected<Team>(selectedTeam))
            
            if isDismissable {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            guard let currentUser = core.state.userState.currentUser else { return }
            if currentUser.owns(selectedTeam) {
                pushTeamCreation(editingTeam: selectedTeam)
            } else {
                presentOptionsForNonOwner(of: selectedTeam)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
