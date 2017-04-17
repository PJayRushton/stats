//
//  GamesViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/17/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class GamesViewController: Component, AutoStoryboardInitializable {

    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var new: Bool = false
    
    fileprivate var ongoingGames: [Game] {
        return core.state.gameState.ongoingGames.sorted(by: { $0.date > $1.date })
    }
    
    fileprivate var games: [Game] {
        guard let team = core.state.teamState.currentTeam else { return [] }
        return core.state.gameState.allGames.filter { $0.teamId == team.id }.sorted { $0.date > $1.date }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.sectionHeaderHeight = 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if new {
            plusButtonPressed(plusButton)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
    }

}

extension GamesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ongoingGames.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ongoingGames.count
        case 1:
            return games.count
        default:
            preconditionFailure()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier) as! GameCell
        let game = indexPath.section == 0 ? ongoingGames[indexPath.row] : games[indexPath.row]
        let order = core.state.gameState.index(of: game)
        cell.update(with: games, order: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if ongoingGames.isEmpty {
            return nil
        }
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let headerText = section == 0 ? "Ongoing" : "Past"
        headerCell.update(text: headerText)
        return headerCell
    }
    
}

extension GamesViewController: UITableViewDelegate {
    
}
