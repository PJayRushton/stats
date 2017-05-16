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
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var new = false
    fileprivate var isReadyToShowNewGame = true
    
    fileprivate var ongoingGames: [Game] {
        return core.state.gameState.ongoingGames.sorted(by: { $0.date > $1.date })
    }
    
    fileprivate var games: [Game] {
        return core.state.gameState.teamGames.filter { $0.isCompleted }.sorted { $0.date > $1.date }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        let headerNib = UINib(nibName: String(describing: BasicHeaderCell.self), bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
        emptyStateLabel.text = NSLocalizedString("ooh your first game!\nHow exciting!", comment: "The player is about to create their first game. And that's awesome")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isReadyToShowNewGame = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if new {
            new = false
            plusButtonPressed(plusButton)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.fire(event: NewGameReadyToShow(ready: false))
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        let newGameVC = GameCreationViewController.initializeFromStoryboard().embededInNavigationController
        newGameVC.modalPresentationStyle = .overFullScreen
        present(newGameVC, animated: true, completion: nil)
    }
    
    @IBAction func emptyStateNewGamePressed(_ sender: UIButton) {
        plusButtonPressed(plusButton)
    }
    
    override func update(with state: AppState) {
        navigationController?.navigationBar.barTintColor = HomeMenuItem.games.backgroundColor
        tableView.backgroundView = games.isEmpty && ongoingGames.isEmpty ? emptyStateView : nil
        tableView.reloadData()
        
        if core.state.newGameState.isReadyToShow && isReadyToShowNewGame {
            isReadyToShowNewGame = false
            let gameVC = GameViewController.initializeFromStoryboard()
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }

}

extension GamesViewController: UITableViewDataSource {
    
    func game(at indexPath: IndexPath) -> Game {
        switch indexPath.section {
        case 0:
            return ongoingGames[indexPath.row]
        case 1:
            return games[indexPath.row]
        default:
            fatalError()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        cell.update(with: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if ongoingGames.isEmpty && games.isEmpty {
            return nil
        }
            
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let headerText = section == 0 ? "Ongoing" : "Finished"
        headerCell.update(with: headerText)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isEmpty = ongoingGames.isEmpty && games.isEmpty
        return isEmpty ? 0 : 30
    }
    
}

extension GamesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = game(at: indexPath)
        core.fire(event: Selected<Game>(selectedGame))
        let gameVC = GameViewController.initializeFromStoryboard()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
}
