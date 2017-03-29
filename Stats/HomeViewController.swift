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

class HomeViewController: Component {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet var emptyStateView: UIView!

    
    // MARK: - Properties
    
    fileprivate let gridLayout = IGListGridCollectionViewLayout()
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var isPresentingOnboarding = false
    
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
        
        core.add(subscriber: self)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - IBActions

    @IBAction func createTeamButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addTeamButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        if state.userState.currentUser == nil && !isPresentingOnboarding {
            isPresentingOnboarding = true
            let usernameVC = UsernameViewController.initializeFromStoryboard().embededInNavigationController
            present(usernameVC, animated: true, completion: nil)
        }
    }
}


// MARK: - CollectionView
// MARK: DataSource

extension HomeViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        guard let currentTeam = core.state.teamState.currentTeam else { return [] }
        return [currentTeam]
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        guard let currentUser = core.state.userState.currentUser else { return IGListSectionController() }
        let homeController = HomeSectionController(user: currentUser)
        homeController.settingsPressed = {}
        homeController.editPressed = {}
        homeController.switchTeamPressed = {}
        return homeController
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyStateView
    }
    
}
