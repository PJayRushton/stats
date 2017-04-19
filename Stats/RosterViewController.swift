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
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var isLineup = false
    
    fileprivate var orderedPlayers = [Player]()
    fileprivate var benchedPlayers = [Player]()
    
    fileprivate var allPlayers: [Player] {
        guard let currentTeam = currentTeam else { return [] }
        return core.state.playerState.players(for: currentTeam).sorted(by: { $0.order < $1.order })
    }
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }

    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.sectionHeaderHeight = isLineup ? 30 : 0
        
        if let lineup = core.state.newGameState.lineup, isLineup {
            orderedPlayers = lineup
            guard let currentTeam = currentTeam else { orderedPlayers = allPlayers; return }
            benchedPlayers = core.state.playerState.players(for: currentTeam).filter { !lineup.contains($0) }
        } else {
            orderedPlayers = allPlayers
        }
        feedbackGenerator.prepare()
        
        let nib = UINib(nibName: PlayerCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PlayerCell.reuseIdentifier)
        let headerNib = UINib(nibName: BasicHeaderCell.reuseIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: BasicHeaderCell.reuseIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isLineup {
            core.fire(event: LinupUpdated(players: orderedPlayers))
        } else {
            updateRosterOrder()
        }
    }
    
    @IBAction func addPlayerButtonPressed(_ sender: UIBarButtonItem) {
        let playerCreationVC = PlayerCreationViewController.initializeFromStoryboard()
        customPresentViewController(modalPresenter(), viewController: playerCreationVC, animated: true, completion: nil)
    }
    
    override func update(with state: AppState) {
        navigationController?.navigationBar.barTintColor = state.currentMenuItem?.backgroundColor
        
        if let currentPlayers = state.playerState.currentPlayers {
            diffOrderedPlayers(with: currentPlayers)
        }
        tableView.reloadData()
    }
    
 }


extension RosterViewController {
    
    fileprivate func modalPresenter(transitionType: TransitionType = .coverHorizontalFromRight) -> Presentr {
        let customPresentation = PresentationType.custom(width: .half, height: .half, center: .center)
        let modalPresentation = PresentationType.popup
        
        let presentationType = UIDevice.current.userInterfaceIdiom == .pad ? customPresentation : modalPresentation
        let presenter = Presentr(presentationType: presentationType)
        presenter.transitionType = transitionType
        presenter.dismissTransitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }

    fileprivate func diffOrderedPlayers(with statePlayers: [Player]) {
        for (index, player) in orderedPlayers.enumerated() {
            guard let trueIndex = statePlayers.index(of: player) else { continue }
            let truePlayer = statePlayers[trueIndex]
            
            if !player.isTheSameAs(truePlayer) {
                orderedPlayers[index] = truePlayer
            }
        }
    }
    
    fileprivate func player(at indexPath: IndexPath) -> Player {
        if indexPath.section == 1 {
            return benchedPlayers[indexPath.row]
        } else {
            return orderedPlayers[indexPath.row]
        }
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
        }
        tableView.endUpdates()
    }
    
    fileprivate func updateCells(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? PlayerCell else { return }
            cell.contentView.fadeTransition(duration: 0.3)
            configure(cell: cell, with: player(at: indexPath), atRow: indexPath.row, isSelected: indexPath.section == 0)
        }
    }
    
    fileprivate func editPlayer(_ player: Player) {
        let playerEditVC = PlayerCreationViewController.initializeFromStoryboard()
        playerEditVC.editingPlayer = player
        customPresentViewController(modalPresenter(), viewController: playerEditVC, animated: true, completion: nil)
    }
    
    fileprivate func updateRosterOrder() {
        for (index, player) in orderedPlayers.enumerated() {
            guard player.order != index else { continue }
            var updatedPlayer = player
            updatedPlayer.order = index
            core.fire(command: UpdateObject(object: updatedPlayer))
        }
    }
    
    fileprivate func callPhoneNumber(_ number: String) {
        guard let phoneURL = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(phoneURL) else { return }
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    }
    
    fileprivate func textPhoneNumber(_ number: String) {
        let textVC = MFMessageComposeViewController(rootViewController: self)
        textVC.recipients = [number]
        textVC.messageComposeDelegate = self
        present(textVC, animated: true, completion: nil)
    }
    
    fileprivate func presentOptions(for player: Player) {
        if let phone = player.phone, !phone.isEmpty {
            let alert = UIAlertController(title: "Actions for:", message: player.name, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Edit ✏️", style: .default, handler: { _ in
                self.editPlayer(player)
            }))
            let callAction = UIAlertAction(title: "Call 📞", style: .default, handler: { _ in
                self.callPhoneNumber(phone)
            })
            
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                alert.addAction(callAction)
            }
            let textAction = UIAlertAction(title: "Text 💬", style: .default, handler: { _ in
                self.textPhoneNumber(phone)
            })
            
            if MFMessageComposeViewController.canSendText() {
                alert.addAction(textAction)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        } else {
            editPlayer(player)
        }
    }

}

extension RosterViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? orderedPlayers.count : benchedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseIdentifier) as! PlayerCell
        configure(cell: cell, with: player(at: indexPath), atRow: indexPath.row, isSelected: indexPath.section == 0)
        
        cell.upButtonPressed = {
            guard let currentIndex = tableView.indexPath(for: cell) else { return }
            self.movePlayer(from: currentIndex, to: IndexPath(row: indexPath.row - 1, section: indexPath.section))
        }
        cell.downButtonPressed = {
            guard let currentIndex = tableView.indexPath(for: cell) else { return }
            self.movePlayer(from: currentIndex, to: IndexPath(row: indexPath.row + 1, section: indexPath.section))
        }
        
        return cell
    }
    
    func configure(cell: PlayerCell, with player: Player, atRow row: Int, isSelected: Bool) {
        cell.update(with: player, order: row, isLast: player == orderedPlayers.last, isSelected: isSelected)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard isLineup else { return nil }
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BasicHeaderCell.reuseIdentifier) as! BasicHeaderCell
        let title = section == 0 ? "Roster" : "Bench"
        headerCell.update(with: title, backgroundColor: .gray200)
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLineup {
            let row = indexPath.section == 0 ? benchedPlayers.count : orderedPlayers.count
            movePlayer(from: indexPath, to: IndexPath(row: row, section: indexPath.section == 0 ? 1 : 0))
        } else {
            let player = orderedPlayers[indexPath.row]
            presentOptions(for: player)
        }
    }
    
}

extension RosterViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
}
