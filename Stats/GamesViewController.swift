//
//  GamesViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/17/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr

class GamesViewController: Component, AutoStoryboardInitializable {

    // MARK: - IBOutlets
    
    @IBOutlet var calendarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    
    // MARK: - Properties
    
    var new = false
    fileprivate var isReadyToShowNewGame = true
    fileprivate var isReadytoShowStats = true
    
    fileprivate var ongoingGames = [Game]()
    fileprivate var regularSeasonGames = [Game]()
    fileprivate var postSeasonGames = [Game]()
    fileprivate var tableIsEmpty = false
    fileprivate var hasPostSeason = false
    fileprivate let tapper = UISelectionFeedbackGenerator()
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapper.prepare()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        emptyStateLabel.text = NSLocalizedString("ooh your first game!\nHow exciting!", comment: "The player is about to create their first game. And that's awesome")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = .mainAppColor

        isReadyToShowNewGame = true
        isReadytoShowStats = true
        
        if new {
            new = false
            presentNewGameVC()
        }
        core.fire(event: StatGameUpdated(game: nil))
        core.fire(command: ProcessGamesForCalendar(from: self))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.fire(event: NewGameReadyToShow(ready: false))
    }
    

    // MARK: - IBActions

    @IBAction func createNewGame() {
        tapper.selectionChanged()
        presentNewGameVC()
    }
    
    @IBAction func emptyStateNewGamePressed(_ sender: UIButton) {
        tapper.selectionChanged()
        createNewGame()
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        if CalendarService.hasCalendarPermission, let processedGames = core.state.gameState.processedGames {
            showCalendarResponseAlert(saveGames: processedGames.gamesToSave, dirtyGames: processedGames.gamesToEdit)
        } else {
            CalendarService.requestCalendarAccess(completion: { granted in
                self.core.fire(command: ProcessGamesForCalendar(from: self, completion: { calendarGames in
                    self.showCalendarResponseAlert(saveGames: calendarGames.gamesToSave, dirtyGames: calendarGames.gamesToEdit)
                }))
            })
        }
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        let gameState = state.gameState
        ongoingGames = gameState.currentOngoingGames.sortedByDate()
        regularSeasonGames = gameState.currentGames(regularSeason: true).sortedByDate()
        postSeasonGames = gameState.currentGames(regularSeason: false).sortedByDate()
        hasPostSeason = !postSeasonGames.isEmpty
        tableIsEmpty = gameState.currentGames.isEmpty
        
        let hasCalendarAction = !CalendarService.hasCalendarPermission || state.gameState.processedGames?.hasSavableGames == true
        navigationItem.rightBarButtonItem = hasCalendarAction ? calendarButton : nil
        tableView.backgroundView = tableIsEmpty ? emptyStateView : nil
        tableView.reloadData()
        
        if core.state.newGameState.isReadyToShow && isReadyToShowNewGame {
            isReadyToShowNewGame = false
            pushDetail()
        }
        if let recentlyCompletedGame = state.gameState.recentlyCompletedGame, isReadytoShowStats {
            isReadytoShowStats = false
            core.fire(event: UpdateRecentlyCompletedGame(game: nil))
            core.fire(event: StatGameUpdated(game: recentlyCompletedGame))
            pushStats()
        }
    }
    
}


// MARK: Fileprivate 

extension GamesViewController {
 
    fileprivate func presentNewGameVC() {
        let newGameVC = GameCreationViewController.initializeFromStoryboard().embededInNavigationController
        newGameVC.modalPresentationStyle = .overFullScreen
        present(newGameVC, animated: true, completion: nil)
    }

    fileprivate func pushDetail() {
        tapper.selectionChanged()
        let gameVC = GameViewController.initializeFromStoryboard()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    fileprivate func presentOptionsAlert(for game: Game) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Show Game", style: .default, handler: { _ in
            self.pushDetail()
        }))
        alert.addAction(UIAlertAction(title: "Show Stats", style: .default, handler: { _ in
            self.pushStats(for: game)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func pushStats(for game: Game? = nil) {
        let statsVC = StatsViewController.initializeFromStoryboard()
        navigationController?.pushViewController(statsVC, animated: true)
        if let game = game {
            saveStatsIfNeeded(for: game)
        }
    }
    
    fileprivate func saveStatsIfNeeded(for game: Game) {
        core.fire(command: UpdateTrophies(for: game))
        
        if core.state.statState.stats(for: game.id) == nil {
            core.fire(command: SaveGameStats(for: game))
        }
    }
    
    fileprivate func showCalendarResponseAlert(saveGames: [Game], dirtyGames: [Game]) {
        if saveGames.isEmpty && dirtyGames.isEmpty {
            showCalendarUpToDateAlert()
            return
        }
        var message = "I found "
        let hasGamesToSave = !saveGames.isEmpty
        let hasDirtyGames = !dirtyGames.isEmpty
        
        if hasGamesToSave {
            message += "\(saveGames.count) new games to add"
        }
        if hasDirtyGames {
            if !saveGames.isEmpty {
                message += " & "
            }
            message += "\(dirtyGames.count) games that need to be updated"
        }
        
        let alert = UIAlertController(title: "Calendar updates", message: message, preferredStyle: .actionSheet)
        
        if hasGamesToSave {
            alert.addAction(UIAlertAction(title: "Save \(saveGames.count) New Games", style: .default, handler: { _ in
                self.core.fire(command: AddGamesToCalendar(saveGames))
                self.showSuccessAlert()
            }))
        }
        
        if hasDirtyGames {
            alert.addAction(UIAlertAction(title: "Update \(dirtyGames.count) games", style: .default, handler: { _ in
                self.core.fire(command: EditCalendarEventForGames(dirtyGames))
                self.showSuccessAlert()
            }))
        }
        if hasGamesToSave && hasDirtyGames {
            alert.addAction(UIAlertAction(title: "Save & Update All", style: .default, handler: { _ in
                self.core.fire(command: AddGamesToCalendar(saveGames))
                self.core.fire(command: EditCalendarEventForGames(dirtyGames))
                self.showSuccessAlert()
            }))
        }
        
        guard !alert.actions.isEmpty else { return }
        alert.addAction(UIAlertAction.cancel)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showCalendarUpToDateAlert() {
        let alert = UIAlertController(title: "You're good to go!", message: "All these games are already in your calendar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "😎", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showSuccessAlert() {
        let alert = UIAlertController(title: "Success!", message: "Games were successfully saved to your default calendar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "👍", style: .cancel, handler: { _ in
            self.core.fire(command: ProcessGamesForCalendar(from: self))
        }))
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - TableView DataSource

extension GamesViewController: UITableViewDataSource {
    
    enum SectionType {
        case ongoing
        case postSeason
        case regularSeason
        
        var headerTitle: String {
            switch self {
            case .ongoing:
                return NSLocalizedString("In Progress", comment: "Followed by the list of games that are still being played")
            case .postSeason:
                return NSLocalizedString("Post Season", comment: "Followed by the list of games completed during season following the regular season e.g playoffs, tournament etc.")
            case .regularSeason:
                return NSLocalizedString("Regular Season", comment: "Followed by the list of games completed during the regular season")
            }
        }
    }
    
    func sectionType(for section: Int) -> SectionType {
        switch section {
        case 0:
            if !ongoingGames.isEmpty {
                return .ongoing
            } else if hasPostSeason {
                return .postSeason
            } else {
                return .regularSeason
            }
        case 1:
            if !ongoingGames.isEmpty {
                return hasPostSeason ? .postSeason : .regularSeason
            } else {
                fallthrough
            }
        default:
            return .regularSeason
        }
    }
    
    func record(for section: Int) -> TeamRecord? {
        switch sectionType(for: section) {
        case .ongoing:
            return nil
        case .postSeason:
            return core.state.gameState.currentGames(regularSeason: false).record
        case .regularSeason:
            return core.state.gameState.currentGames(regularSeason: true).record
        }
    }
    
    func games(for section: Int) -> [Game] {
        switch sectionType(for: section) {
        case .ongoing:
            return ongoingGames
        case .postSeason:
            return postSeasonGames
        case .regularSeason:
            return regularSeasonGames
        }
    }
    
    func game(at indexPath: IndexPath) -> Game {
        return games(for: indexPath.section)[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        for gamesArray in [ongoingGames, postSeasonGames, regularSeasonGames] {
            if !gamesArray.isEmpty {
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier) as! GameCell
        let gameAtIndex = game(at: indexPath)
        cell.update(with: gameAtIndex)
        cell.accessoryType = sectionType(for: indexPath.section) == .ongoing ? .disclosureIndicator : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !tableIsEmpty else { return nil }
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: GamesHeaderCell.reuseIdentifier) as! GamesHeaderCell
        let title = sectionType(for: section).headerTitle
        let seasonRecord = record(for: section)
        headerCell.update(withTitle: title, record: seasonRecord)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableIsEmpty ? 0 : 34
    }
    
}


// MARK: - TableView Delegate

extension GamesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = game(at: indexPath)
        core.fire(event: Selected<Game>(selectedGame))
        core.fire(event: StatGameUpdated(game: selectedGame))
        
        if sectionType(for: indexPath.section) == .ongoing {
            pushDetail()
        } else {
            presentOptionsAlert(for: selectedGame)
        }
    }
    
}
