//
//  SeasonsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class SeasonsViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    fileprivate var seasons: [Season] {
        guard let team = currentTeam else { return [] }
        return core.state.seasonState.seasons(for: team)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.mainAppColor
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func update(with state: AppState) {
        if let currentTeam = state.teamState.currentTeam, let user = state.userState.currentUser, user.isOwnerOrManager(of: currentTeam) {
            navigationItem.rightBarButtonItem = plusButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.reloadData()
    }
    
}

extension SeasonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeasonTableCell.reuseIdentifier) as! SeasonTableCell
        let season = seasons[indexPath.row]
        let isCurrent = currentTeam?.currentSeasonId == season.id
        cell.update(with: seasons[indexPath.row], isCurrent: isCurrent)
        return cell
    }
    
}

extension SeasonsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if seasons.count == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let selectedSeason = seasons[indexPath.row]
        core.fire(event: Selected<Season>(selectedSeason))
    }
    
}
