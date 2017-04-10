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

class RosterViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var orderedPlayers = [Player]()
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    fileprivate let modalPresenter: Presentr = {
        let customPresentation = PresentationType.custom(width: .half, height: .half, center: .center)
        let modalPresentation = PresentationType.popup
        
        let presentationType = UIDevice.current.userInterfaceIdiom == .pad ? customPresentation : modalPresentation
        let presenter = Presentr(presentationType: presentationType)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
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
        customPresentViewController(modalPresenter, viewController: playerCreationVC, animated: true, completion: nil)
    }
    
    override func update(with: AppState) {
        navigationController?.navigationBar.barTintColor = core.state.currentMenuItem?.backgroundColor
        tableView.reloadData()
    }
    
 }


extension RosterViewController {
    
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

    fileprivate func updateRosterOrder() {
        for (index, player) in orderedPlayers.enumerated() {
            guard player.order != index else { continue }
            var updatedPlayer = player
            updatedPlayer.order = index
            core.fire(command: UpdateObject(object: updatedPlayer))
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
    
}
