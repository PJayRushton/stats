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
    
    fileprivate var orderedPlayers = [Player]()
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    fileprivate var allPlayers: [Player] {
        guard let currentTeam = currentTeam else { return [] }
        return core.state.playerState.players(for: currentTeam).sorted(by: { $0.order < $1.order })
    }
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        orderedPlayers = allPlayers
        feedbackGenerator.prepare()
        
        let nib = UINib(nibName: PlayerCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PlayerCell.reuseIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateRosterOrder()
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
    
    func moveButtonPressed(for player: Player, up: Bool = true) {
        guard let index = orderedPlayers.index(of: player), !(!up && index == orderedPlayers.count - 1), !(up && index == 0) else { return }
        feedbackGenerator.selectionChanged()
        tableView.beginUpdates()
        orderedPlayers.remove(at: index)
        let newIndex = up ? index - 1 : index + 1
        orderedPlayers.insert(player, at: newIndex)
        let indexToMove = IndexPath(row: index, section: 0)
        let indexToArrive = IndexPath(row: newIndex, section: 0)
        tableView.moveRow(at: indexToMove, to: indexToArrive)
        tableView.endUpdates()
        
        tableView.beginUpdates()
        updateCells(at: [indexToMove, indexToArrive])
        tableView.endUpdates()
    }
    
    fileprivate func updateCells(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? PlayerCell else { return }
            cell.contentView.fadeTransition(duration: 0.3)
            configure(cell: cell, with: orderedPlayers[indexPath.row], atRow: indexPath.row)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseIdentifier) as! PlayerCell
        let player = orderedPlayers[indexPath.row]
        configure(cell: cell, with: player, atRow: indexPath.row)
        cell.upButtonPressed = {
            self.moveButtonPressed(for: player, up: true)
        }
        cell.downButtonPressed = {
            self.moveButtonPressed(for: player, up: false)
        }
        
        return cell
    }
    
    func configure(cell: PlayerCell, with player: Player, atRow row: Int) {
        cell.update(with: player, order: row, isLast: player == orderedPlayers.last)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = orderedPlayers[indexPath.row]
        presentOptions(for: player)
    }
    
}

extension RosterViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
}
