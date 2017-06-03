//
//  SeasonsViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr

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


extension SeasonsViewController {
    
    fileprivate func showOptions(for season: Season ) {
        let alert = UIAlertController(title: "Options for \(season.name)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Set as current", style: .default, handler: { _ in
//            self.setCurrentSeason(season)
        }))
        alert.addAction(UIAlertAction(title: "Edit ✏️", style: .default, handler: { _ in
            self.editSeason(season)
        }))
        alert.addAction(UIAlertAction(title: "Delete ☠️", style: .destructive, handler: { _ in
            self.showDeleteConfirmation(for: season)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setCurrentSeaons(_ season: Season) {
        guard var currentTeam = core.state.teamState.currentTeam else { return }
        currentTeam.currentSeasonId = season.id
        core.fire(command: UpdateObject(currentTeam))
    }
    
    fileprivate func editSeason(_ season: Season) {
        let textEditVC = TextEditViewController.initializeFromStoryboard()
        textEditVC.topText = "Edit Season Name"
//        textEditVC.savePressed =
//        present(textEditVC, animated: true, completion: nil)
    }
    
    func savePressed(newName: String) {
        
    }
    
    fileprivate func showDeleteConfirmation(for season: Season) {
        let alert = Presentr.alertViewController(title: "ARE YOU SURE??", body: "This will delete all the GAMES & STATS for this season! 😱")
        alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            self.core.fire(command: DeleteSeason(season))
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
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
