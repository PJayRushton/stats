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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - IBActions

    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        let teamCreationVC = TeamCreationViewController.initializeFromStoryboard().embededInNavigationController
        present(teamCreationVC, animated: true, completion: nil)
    }
    
    @IBAction func addTeamButtonPressed(_ sender: UIButton) {
        let addTeamVC = AddTeamViewController.initializeFromStoryboard().embededInNavigationController
        present(addTeamVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if state.userState.currentUser == nil, state.userState.isLoaded, !isPresentingOnboarding {
            isPresentingOnboarding = true
            let usernameVC = UsernameViewController.initializeFromStoryboard().embededInNavigationController
            present(usernameVC, animated: true)
        }
        adapter.performUpdates(animated: true)
    }
    
}

extension HomeViewController {
    
    func presentSettings() {
        let settingsVC = SettingsViewController.initializeFromStoryboard().embededInNavigationController
        present(settingsVC, animated: true, completion: nil)
    }
    
    func presentTeamSwitcher() {
        let switcherVC = TeamSwitcherViewController.initializeFromStoryboard().embededInNavigationController
        present(switcherVC, animated: true)
    }
    
    func presentTeamEdit() {
        let creationVC = TeamCreationViewController.initializeFromStoryboard()
        creationVC.editingTeam = currentTeam
        present(creationVC.embededInNavigationController, animated: true, completion: nil)
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
            return actionController
        default:
            fatalError()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyStateView
    }
    
}
