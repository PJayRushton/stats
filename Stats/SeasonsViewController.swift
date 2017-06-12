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
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!

    
    // MARK: - Public
    
    var isModal = false
    
    
    // MARK: - Properties
    
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    fileprivate var seasons: [Season] {
        guard let team = currentTeam else { return [] }
        return core.state.seasonState.seasons(for: team)
    }
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainAppColor
        navigationItem.leftBarButtonItem = isModal ? dismissButton : nil
    }

    
    // MARK: - IBActions
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        createSeason()
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if let currentTeam = state.teamState.currentTeam, let user = state.userState.currentUser, user.isOwnerOrManager(of: currentTeam) {
            navigationItem.rightBarButtonItem = plusButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.reloadData()
    }
    
}


// MARK: - Private

extension SeasonsViewController {
    
    fileprivate func showOptions(for season: Season ) {
        let alert = UIAlertController(title: "Options for \(season.name)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let viewAction = UIAlertAction(title: "View season", style: .default) { _ in
            self.core.fire(event: Selected<Season>(season))
        }
        let setCurrentAction = UIAlertAction(title: "Set as current", style: .default) { _ in
            self.setCurrentSeason(season)
        }
        let editAction = UIAlertAction(title: "Edit ✏️", style: .default) { _ in
            self.editSeason(season)
        }
        let deleteAction = UIAlertAction(title: "Delete ☠️", style: .destructive) { _ in
            self.showDeleteConfirmation(for: season)
        }
        
        guard let currentUser = core.state.userState.currentUser, let currentTeam = currentTeam else { return }
        
        if currentUser.owns(currentTeam) {
            alert.addAction(viewAction)
            
            if currentTeam.currentSeasonId != season.id {
                alert.addAction(setCurrentAction)
            }
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            core.fire(event: Selected<Season>(season))
        }
    }
    
    fileprivate func setCurrentSeason(_ season: Season) {
        guard var currentTeam = core.state.teamState.currentTeam else { return }
        currentTeam.currentSeasonId = season.id
        core.fire(command: UpdateObject(currentTeam))
    }
    
    fileprivate func createSeason() {
        let textEditVC = TextEditViewController.initializeFromStoryboard()
        textEditVC.topLabelText = NSLocalizedString("New Season", comment: "")
        textEditVC.placeholder = "Season name"
        textEditVC.savePressed = { text in
            self.saveSeason(name: text)
        }
        customPresentViewController(TextEditViewController.presenter, viewController: textEditVC, animated: true, completion: nil)
    }
    
    fileprivate func editSeason(_ season: Season) {
        let textEditVC = TextEditViewController.initializeFromStoryboard()
        textEditVC.topLabelText = NSLocalizedString("Edit Season Name", comment: "")
        textEditVC.editingText = season.name
        textEditVC.placeholder = "Season name"
        textEditVC.savePressed = { text in
            self.saveSeason(season, name: text)
        }
        customPresentViewController(TextEditViewController.presenter, viewController: textEditVC, animated: true, completion: nil)
    }
    
    fileprivate func saveSeason(_ season: Season? = nil, name: String) {
        if var updatedSeason = season {
            updatedSeason.name = name
            core.fire(command: UpdateObject(updatedSeason))
        } else if let currentTeam = core.state.teamState.currentTeam {
            core.fire(command: CreateSeason(name: name, teamId: currentTeam.id))
        }
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


// MARK: - Tableview

extension SeasonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeasonTableCell.reuseIdentifier) as! SeasonTableCell
        let season = seasons[indexPath.row]
        let isCurrent = currentTeam?.currentSeasonId == season.id
        let isViewing = core.state.seasonState.currentSeasonId == season.id
        cell.update(with: seasons[indexPath.row], isCurrent: isCurrent, isViewing: isViewing)
        
        return cell
    }
    
}


// MARK: - Tableview Delegate

extension SeasonsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSeason = seasons[indexPath.row]
        showOptions(for: selectedSeason)
    }
    
}
