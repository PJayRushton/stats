//
//  HomeViewController.swift
//  St@s
//
//  Created by Parker Rushton on 1/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit
import Presentr

class HomeViewController: Component, AutoStoryboardInitializable {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet var emptyStateView: UIView!

    
    // MARK: - Properties
    
    fileprivate let gridLayout = IGListGridCollectionViewLayout()
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var isPresentingOnboarding = false
    
    var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridLayout.minimumLineSpacing = 0
        gridLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = gridLayout
        adapter.collectionView = collectionView
        adapter.dataSource = self
        feedbackGenerator.prepare()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        adapter.performUpdates(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - IBActions

    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        let teamCreationVC = TeamCreationViewController.initializeFromStoryboard().embededInNavigationController
        teamCreationVC.modalPresentationStyle = .overFullScreen
        present(teamCreationVC, animated: true, completion: nil)
    }
    
    @IBAction func addTeamButtonPressed(_ sender: UIButton) {
        let addTeamVC = AddTeamViewController.initializeFromStoryboard().embededInNavigationController
        addTeamVC.modalPresentationStyle = .overFullScreen
        present(addTeamVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if state.userState.currentUser == nil, state.userState.isLoaded, !isPresentingOnboarding {
            isPresentingOnboarding = true
            let usernameVC = UsernameViewController.initializeFromStoryboard().embededInNavigationController
            usernameVC.modalPresentationStyle = .overFullScreen
            present(usernameVC, animated: true)
        }
        adapter.performUpdates(animated: true)
    }
    
}

extension HomeViewController {
    
    func presentSettings() {
        let settingsVC = SettingsViewController.initializeFromStoryboard().embededInNavigationController
        settingsVC.modalPresentationStyle = .overFullScreen
        present(settingsVC, animated: true, completion: nil)
    }
    
    func presentTeamSwitcher() {
        let switcherVC = TeamSwitcherViewController.initializeFromStoryboard().embededInNavigationController
        switcherVC.modalPresentationStyle = .overFullScreen
        present(switcherVC, animated: true)
    }
    
    func presentTeamEdit() {
        let creationVC = TeamCreationViewController.initializeFromStoryboard()
        creationVC.editingTeam = currentTeam
        let creationVCWithNav = creationVC.embededInNavigationController
        creationVCWithNav.modalPresentationStyle = .overFullScreen
        present(creationVCWithNav, animated: true, completion: nil)
    }
    
    fileprivate func pushGames(new: Bool = false) {
        let gamesVC = GamesViewController.initializeFromStoryboard()
        gamesVC.new = new
        navigationController?.pushViewController(gamesVC, animated: true)
    }
    
    func pushRoster() {
        let rosterVC = RosterViewController.initializeFromStoryboard()
        navigationController?.pushViewController(rosterVC, animated: true)
    }
    
    func pushShareTeamRoles() {
        if let user = core.state.userState.currentUser, let team = core.state.teamState.currentTeam, !user.isOwnerOrManager(of: team) {
            let shareTeamRolesVC = ShareTeamRolesViewController.initializeFromStoryboard()
            navigationController?.pushViewController(shareTeamRolesVC, animated: true)
        } else {
            let shareTeamVC = ShareTeamViewController.initializeFromStoryboard()
            shareTeamVC.modalPresentationStyle = .overFullScreen
            present(shareTeamVC, animated: false, completion: nil)
        }
    }
    
    func didSelectItem(_ item: HomeMenuItem) {
        core.fire(event: Selected<HomeMenuItem>(item))
        switch item {
        case .newGame:
            pushGames(new: true)
            break
        case .stats:
            break
        case .games:
            pushGames()
        case .roster:
            pushRoster()
        case .share:
            pushShareTeamRoles()
        }
    }
    
}


// MARK: - CollectionView
// MARK: DataSource

extension HomeViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        guard let currentTeam = currentTeam, let currentUser = core.state.userState.currentUser else { return [] }
        var objects: [IGListDiffable] = [TeamHeaderSection(team: currentTeam)]
        let items = currentUser.isOwnerOrManager(of: currentTeam) ? HomeMenuItem.managerItems : HomeMenuItem.fanItems
        
        items.forEach { item in
            objects.append(TeamActionSection(team: currentTeam, menuItem: item))
        }
        return objects
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case _ as TeamHeaderSection:
            guard let currentUser = core.state.userState.currentUser else { return IGListSectionController() }
            let headerController = TeamHeaderSectionController(user: currentUser)
            headerController.settingsPressed = presentSettings
            headerController.editPressed = presentTeamEdit
            headerController.switchTeamPressed = presentTeamSwitcher
            return headerController
            
        case _ as TeamActionSection:
            guard let currentUser = core.state.userState.currentUser else { return IGListSectionController() }
            let actionController = TeamActionSectionController(user: currentUser)
            actionController.didSelectItem = didSelectItem
            return actionController
        default:
            fatalError()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyStateView
    }
    
}
