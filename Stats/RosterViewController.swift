//
//  RosterViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit
import Presentr
import Messages
import MessageUI

class RosterViewController: Component, AutoStoryboardInitializable {
    
    enum RosterSection: Int {
        case ordered
        case bench
    }
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var textBarButton: UIBarButtonItem!
    @IBOutlet weak var textButton: CustomButton!
    
    var isLineup = false
    
    fileprivate var orderedPlayers = [Player]()
    fileprivate var benchedPlayers = [Player]()
    fileprivate var orderedPlayersWithCell: [Player] {
        return orderedPlayers.filter { $0.hasCellPhone }
    }
    fileprivate var benchedPlayersWithCell: [Player] {
        return benchedPlayers.filter { $0.hasCellPhone }
    }

    fileprivate var playersToText = [Player]() {
        didSet {
            textButton.isEnabled = !playersToText.isEmpty
            tableView.reloadData()
        }
    }
    fileprivate var isTexting = false {
        didSet {
            tableView.isEditing = !isTexting
            textBarButton.image = isTexting ? #imageLiteral(resourceName: "rosterBar") : #imageLiteral(resourceName: "textMessage")
            if orderedPlayersWithCell.isEmpty {
                navigationItem.rightBarButtonItems = [addButton]
            } else {
                navigationItem.rightBarButtonItems = isTexting ? [textBarButton] : [addButton, textBarButton]
            }
            
            guard isTexting != oldValue else { return }
            playersToText = orderedPlayers.filter { $0.hasCellPhone }
            UIView.animate(withDuration: 0.25) {
                self.textButton.isHidden = !self.isTexting
            }
            tableView.reloadData()
        }
    }
    
    fileprivate var allPlayers: [Player] {
        guard let currentTeam = currentTeam else { return [] }
        return core.state.playerState.currentPlayers(for: currentTeam.id).sorted(by: { $0.order < $1.order })
    }
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }

    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        tableView.isEditing = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        if isLineup, let lineup = core.state.newGameState.lineup {
            orderedPlayers = lineup
            benchedPlayers = allPlayers.filter { !lineup.contains($0) }
        } else {
            orderedPlayers = allPlayers.filter { $0.order >= 0 }.sorted { $0.order < $1.order }
            benchedPlayers = allPlayers.filter { $0.order < 0 }.sorted { $0.name < $1.name }
        }
        playersToText = orderedPlayersWithCell // auto select all players with phone numbers to start
        feedbackGenerator.prepare()
        registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = .mainAppColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isLineup {
            core.fire(event: LineupUpdated(players: orderedPlayers))
        } else {
            updateRosterOrder()
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func addPlayerButtonPressed(_ sender: Any) {
        feedbackGenerator.selectionChanged()
        let playerCreationVC = PlayerCreationViewController.initializeFromStoryboard()
        present(playerCreationVC, animated: true, completion: nil)
    }
    
    @IBAction func textBarButtonPressed(_ sender: Any) {
        feedbackGenerator.selectionChanged()
        isTexting = !isTexting
    }
    
    @IBAction func launchTextButtonPressed(_ sender: UIButton) {
        feedbackGenerator.selectionChanged()
        textPhoneNumbers(playersToText.compactMap { $0.phone })
    }
    
    
    // MARK: - Reactor
    
    override func update(with state: AppState) {
        self.isTexting = isTexting ? true : false // to not duplicate bar button item logic
        guard let team = state.teamState.currentTeam else { tableView.reloadData(); return }
        if isLineup {
            let newPlayers = state.playerState.players(for: team).filter { !orderedPlayers.contains($0) && !benchedPlayers.contains($0) }
            orderedPlayers.append(contentsOf: newPlayers)
        } else {
            orderedPlayers = state.playerState.currentPlayers(for: team.id).filter { !benchedPlayers.contains($0) }
            for (index, player) in benchedPlayers.enumerated() {
                let teamPlayers = state.playerState.players(for: team)
                if let statePlayerIndex = teamPlayers.index(of: player), case let statePlayer = teamPlayers[statePlayerIndex], !player.isSame(as: statePlayer) {
                    benchedPlayers[index] = statePlayer
                }
            }
        }
        let isEmpty = orderedPlayers.isEmpty && benchedPlayers.isEmpty
        tableView.backgroundView = isEmpty ? emptyView : nil
        tableView.reloadData()
    }
    
 }


extension RosterViewController {
    
    fileprivate func registerNibs() {
        let nib = UINib(nibName: PlayerCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PlayerCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
    }
    
    fileprivate func player(at indexPath: IndexPath) -> Player {
        switch RosterSection(rawValue: indexPath.section)! {
        case .ordered:
            return isTexting ? orderedPlayersWithCell[indexPath.row] : orderedPlayers[indexPath.row]
        case .bench:
            return isTexting ? benchedPlayersWithCell[indexPath.row] : benchedPlayers[indexPath.row]
        }
    }
    
    func switchPlayerSection(at indexPath: IndexPath) {
        var toIndex = IndexPath()
        if indexPath.section == 0 {
            toIndex = IndexPath(row: benchedPlayers.count, section: 1)
        } else {
            toIndex = IndexPath(row: orderedPlayers.count, section: 0)
        }
        movePlayer(from: indexPath, to: toIndex)
    }
    
    func movePlayer(from fromIndex: IndexPath, to toIndex: IndexPath) {
        feedbackGenerator.selectionChanged()
        tableView.beginUpdates()
        
        var playerToRemove: Player?
        if fromIndex.section == 1 {
            playerToRemove = benchedPlayers.remove(at: fromIndex.row)
        } else {
            playerToRemove = orderedPlayers.remove(at: fromIndex.row)
        }
        
        guard let removedPlayer = playerToRemove else { return }
        
        if toIndex.section == 1 {
            benchedPlayers.append(removedPlayer)
        } else {
            orderedPlayers.insert(removedPlayer, at: toIndex.row)
        }
        tableView.moveRow(at: fromIndex, to: toIndex)
        tableView.endUpdates()
        
        tableView.beginUpdates()
        updateCells(at: [fromIndex, toIndex])
        
        if fromIndex.section == 0 && toIndex.section == 1 {
            var indexPathsOutOfOrder = [IndexPath]()
            for index in fromIndex.row..<orderedPlayers.count {
                indexPathsOutOfOrder.append(IndexPath(row: index, section: 0))
            }
            updateCells(at: indexPathsOutOfOrder)
        } else if fromIndex.section == 1 && toIndex.section == 0, orderedPlayers.count > 1 {
            let indexPath = IndexPath(row: orderedPlayers.count - 2, section: 0)
            updateCells(at: [indexPath])
        }
        tableView.endUpdates()
    }
    
    fileprivate func updateCells(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? PlayerCell else { return }
            cell.contentView.fadeTransition(duration: 0.3)
            configure(cell: cell, with: player(at: indexPath), atIndex: indexPath, isActive: indexPath.section == 0)
        }
    }
    
    fileprivate func presentEditPlayer(_ player: Player) {
        let playerEditVC = PlayerCreationViewController.initializeFromStoryboard()
        playerEditVC.editingPlayer = player
        present(playerEditVC, animated: true, completion: nil)
    }
    
    fileprivate func updateRosterOrder() {
        for (index, player) in orderedPlayers.enumerated() {
            guard player.order != index else { continue }
            var updatedPlayer = player
            updatedPlayer.order = index
            core.fire(command: UpdateObject(updatedPlayer))
        }
        benchedPlayers.forEach { player in
            var updatedPlayer = player
            updatedPlayer.order = -1
            core.fire(command: UpdateObject(updatedPlayer))
        }
    }
    
    fileprivate func textPhoneNumbers(_ numbers: [String]) {
        guard !Platform.isSimulator else { return }
        
        let textVC = MFMessageComposeViewController()
        textVC.recipients = numbers
        textVC.messageComposeDelegate = self
        present(textVC, animated: true, completion: nil)
    }
    
    fileprivate func presentOptions(for player: Player) {
        let alert = UIAlertController(title: player.name, message: player.phone, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let currentUser = core.state.userState.currentUser, let team = core.state.teamState.currentTeam, currentUser.isOwnerOrManager(of: team) {
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                self.presentEditPlayer(player)
            }))
            if player.phone == nil || (player.phone != nil && player.phone!.isEmpty) {
                presentEditPlayer(player)
            }
        }
        
        if let phone = player.phone, !phone.isEmpty {
            if let phoneURL = player.phoneURL, UIApplication.shared.canOpenURL(phoneURL) {
                alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }))
            }
            if MFMessageComposeViewController.canSendText() {
                alert.addAction(UIAlertAction(title: "Text", style: .default, handler: { _ in
                    self.textPhoneNumbers([phone])
                }))
            }
        }
        
        present(alert, animated: true, completion: nil)
    }

}

extension RosterViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch RosterSection(rawValue: section)! {
        case .ordered:
            return isTexting ? orderedPlayersWithCell.count : orderedPlayers.count
        case .bench:
            return isTexting ? benchedPlayersWithCell.count : benchedPlayers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseIdentifier) as! PlayerCell
        cell.isTexting = isTexting
        let playerAtRow = player(at: indexPath)
        let playerIsActive = isTexting && playersToText.contains(playerAtRow)
        configure(cell: cell, with: playerAtRow, atIndex: indexPath, isActive: playerIsActive)
        
        return cell
    }
    
    func configure(cell: PlayerCell, with player: Player, atIndex index: IndexPath, isActive: Bool) {
        cell.update(with: player, index: index, isActive: isActive)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let title = section == 0 ? NSLocalizedString("Roster", comment: "Main players on the team") : NSLocalizedString("Bench", comment: "Not currently playing, (on the bench)")
        headerCell.update(with: title)
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isEmpty = orderedPlayers.isEmpty && benchedPlayers.isEmpty
        return isEmpty ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedbackGenerator.selectionChanged()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPlayer = player(at: indexPath)
        if isTexting {
            if let index = playersToText.index(of: selectedPlayer) {
                playersToText.remove(at: index)
            } else {
                playersToText.append(selectedPlayer)
            }
        } else {
            if isLineup {
                switchPlayerSection(at: indexPath)
            } else {
                presentOptions(for: selectedPlayer)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let currentUser = core.state.userState.currentUser, let team = core.state.teamState.currentTeam else { return false }
        return currentUser.isOwnerOrManager(of: team)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let currentUser = core.state.userState.currentUser, let team = core.state.teamState.currentTeam else { return false }
        return currentUser.isOwnerOrManager(of: team)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedPlayer = sourceIndexPath.section == RosterSection.ordered.rawValue ? orderedPlayers.remove(at: sourceIndexPath.row) : benchedPlayers.remove(at: sourceIndexPath.row)
        switch RosterSection(rawValue: destinationIndexPath.section)! {
        case .ordered:
            orderedPlayers.insert(movedPlayer, at: destinationIndexPath.row)
        case .bench:
            benchedPlayers.insert(movedPlayer, at: destinationIndexPath.row)
        }
        updateRosterOrder()
    }
    
}

extension RosterViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
}
