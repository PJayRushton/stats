//
//  HomeViewController.swift
//  St@s
//
//  Created by Parker Rushton on 1/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher
import Presentr

class HomeViewController: Component, AutoStoryboardInitializable {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!

    
    // MARK: - Properties
    
    fileprivate let gridLayout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var isPresentingOnboarding = false
    
    var currentTeam: Team? {
        return core.state.teamState.currentTeam
    }
    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - IBActions

    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        feedbackGenerator.selectionChanged()
        let teamCreationVC = TeamCreationViewController.initializeFromStoryboard().embededInNavigationController
        teamCreationVC.modalPresentationStyle = .overFullScreen
        present(teamCreationVC, animated: true, completion: nil)
    }
    
    @IBAction func addTeamButtonPressed(_ sender: UIButton) {
        feedbackGenerator.selectionChanged()
        let addTeamVC = AddTeamViewController.initializeFromStoryboard().embededInNavigationController
        addTeamVC.modalPresentationStyle = .overFullScreen
        present(addTeamVC, animated: true, completion: nil)
    }
    
    @IBAction func newTeamButtonPressed(_ sender: UIButton) {
        pushGames(new: true)
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if state.userState.currentUser == nil, state.userState.isLoaded, !isPresentingOnboarding {
            isPresentingOnboarding = true
            let usernameVC = NewUserViewController.initializeFromStoryboard().embededInNavigationController
            usernameVC.modalPresentationStyle = .overFullScreen
            present(usernameVC, animated: true)
        }
        
        if let user = state.userState.currentUser, let currentTeam = currentTeam {
            newGameButton.isHidden = !user.isOwnerOrManager(of: currentTeam)
        }
        adapter.performUpdates(animated: true)
    }
    
}


extension HomeViewController {
    
    func presentSettings() {
        feedbackGenerator.selectionChanged()
        let settingsVC = SettingsViewController.initializeFromStoryboard().embededInNavigationController
        settingsVC.modalPresentationStyle = .overFullScreen
        present(settingsVC, animated: true, completion: nil)
    }
    
    func presentTeamSwitcher() {
        feedbackGenerator.selectionChanged()
        let teamListVC = TeamListViewController.initializeFromStoryboard()
        teamListVC.isSwitcher = true
        let teamListInNav = teamListVC.embededInNavigationController
        teamListInNav.modalTransitionStyle = .flipHorizontal
        teamListInNav.modalPresentationStyle = .fullScreen
        present(teamListInNav, animated: true)
    }
    
    func presentTeamEdit() {
        feedbackGenerator.selectionChanged()
        let creationVC = TeamCreationViewController.initializeFromStoryboard()
        creationVC.editingTeam = currentTeam
        let creationVCWithNav = creationVC.embededInNavigationController
        creationVCWithNav.modalPresentationStyle = .overFullScreen
        present(creationVCWithNav, animated: true, completion: nil)
    }
    
    func presentSeasonManager() {
        feedbackGenerator.selectionChanged()
        let seasonsVC = SeasonsViewController.initializeFromStoryboard()
        seasonsVC.isModal = true
        let seasonsNav = seasonsVC.embededInNavigationController
        seasonsNav.modalPresentationStyle = .overFullScreen
        present(seasonsNav, animated: true, completion: nil)
    }
    
    fileprivate func pushGames(new: Bool = false) {
        let gamesVC = GamesViewController.initializeFromStoryboard()
        gamesVC.new = new
        navigationController?.pushViewController(gamesVC, animated: true)
    }
    
    fileprivate func pushStats() {
        let statsVC = StatsViewController.initializeFromStoryboard()
        navigationController?.pushViewController(statsVC, animated: true)
    }
    
    func pushRoster() {
        let rosterVC = RosterViewController.initializeFromStoryboard()
        navigationController?.pushViewController(rosterVC, animated: true)
    }
    
    func pushShareTeamRoles() {
        if let user = core.state.userState.currentUser, let team = core.state.teamState.currentTeam, user.isOwnerOrManager(of: team) {
            presentShareRoles()
            let shareTeamRolesVC = ShareTeamRolesViewController.initializeFromStoryboard()
            navigationController?.pushViewController(shareTeamRolesVC, animated: true)
        } else {
            presentTeamShare(withType: .fan)
        }
    }
    
    fileprivate func presentShareRoles() {
        let alert = Presentr.alertViewController(title: "Share Team", body: "Which would you like to add?")
        alert.addAction(AlertAction(title: "St@ Keeper", style: .default, handler: {
            self.dismiss(animated: true, completion: { 
                self.presentTeamShare(withType: .managed)
            })
        }))
        
        alert.addAction(AlertAction(title: "Player/Fan", style: .default, handler: {
            self.dismiss(animated: true, completion: { 
                self.presentTeamShare(withType: .fan)
            })
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    fileprivate func presentTeamShare(withType type: TeamOwnershipType) {
        let shareTeamVC = ShareTeamViewController.initializeFromStoryboard()
        shareTeamVC.modalPresentationStyle = .overFullScreen
        shareTeamVC.ownershipType = type
        present(shareTeamVC, animated: false, completion: nil)
    }
    
    func didSelectItem(_ item: HomeMenuItem) {
        feedbackGenerator.selectionChanged()
        core.fire(event: Selected<HomeMenuItem>(item))
        switch item {
        case .newGame:
            pushGames(new: true)
        case .stats:
            pushStats()
        case .games:
            pushGames()
        case .roster:
            pushRoster()
        case .share:
            pushShareTeamRoles()
        }
    }
    
}


// MARK: - IGListKitDataSource

extension HomeViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let currentTeam = currentTeam else { return [] }
        var objects: [ListDiffable] = [TeamHeaderSection(team: currentTeam, season: core.state.seasonState.currentSeason)]
        let items = HomeMenuItem.allValues
        
        items.forEach { item in
            objects.append(TeamActionSection(team: currentTeam, menuItem: item))
        }
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case _ as TeamHeaderSection:
            let headerController = TeamHeaderSectionController()
            headerController.settingsPressed = presentSettings
            headerController.switchTeamPressed = presentTeamSwitcher
            headerController.seasonPressed = presentSeasonManager
            return headerController
            
        case _ as TeamActionSection:
            let actionController = TeamActionSectionController()
            actionController.didSelectItem = didSelectItem
            return actionController
        default:
            fatalError()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyStateView
    }
    
}
