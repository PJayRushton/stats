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
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
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
        return core.state.playerState.players(for: currentTeam)
    }
    fileprivate var regularPlayers = [Player]()
    fileprivate var subs = [Player]()
    fileprivate var orderedPlayers: [Player] {
        return [regularPlayers, subs].joined().flatMap { $0 }
    }
    fileprivate var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    
    fileprivate var hasSubs: Bool {
        return !subs.isEmpty
    }
    
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPlayers()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        feedbackGenerator.prepare()
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
        adapter.performUpdates(animated: true)
    }
    
}


extension RosterViewController {
    
    fileprivate func setUpPlayers() {
        guard let currentTeam = currentTeam else { return }
        let teamPlayers = core.state.playerState.players(for: currentTeam)
        regularPlayers = teamPlayers.filter { !$0.isSub }.sorted { $0.order < $1.order }
        subs = teamPlayers.filter { $0.isSub }.sorted { $0.name < $1.name }
    }
    
    func didSelectPlayer(_ player: Player) {
        print("did Select player: \(player)")
    }
    
    func upButtonPressed(for player: Player) {
        if let index = regularPlayers.index(of: player) {
            regularPlayers.remove(at: index)
            regularPlayers.insert(player, at: index - 1)
            adapter.performUpdates(animated: true)
        }
    }
    
    fileprivate func updateRosterOrder() {
        for (index, player) in regularPlayers.enumerated() {
            guard player.order != index else { return }
            var updatedPlayer = player
            updatedPlayer.order = index
            core.fire(command: UpdateObject(object: updatedPlayer))
        }
    }
    
}

extension RosterViewController {
    
    enum RosterSection: Int {
        case regular
        case sub
        
        static let allValues = [RosterSection.regular, .sub]
        
        var sectionTitle: String {
            switch self {
            case .regular:
                return "Regulars"
            case .sub:
                return "Subs"
            }
        }
        
    }
    
}

extension RosterViewController: IGListAdapterDataSource {
    
    fileprivate func players(forSection section: RosterSection) -> [Player] {
        switch section {
        case .regular:
            return regularPlayers
        case .sub:
            return subs
        }
    }
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return orderedPlayers.map(PlayerSection.init)
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        guard let playerSection = object as? PlayerSection, let index = orderedPlayers.index(of: playerSection.player) else { return IGListSectionController() }
        let sectionController = PlayerSectionController(order: index)
        sectionController.didSelectPlayer = didSelectPlayer
        sectionController.didUpPlayer = upButtonPressed
        return sectionController
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}
