//
//  StatsTrophiesViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit

class StatsTrophiesViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var emptyViewButton: UIButton!

    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        emptyViewButton.backgroundColor = .mainAppColor
    }
    
    override func update(with state: AppState) {
        adapter.performUpdates(animated: true)
    }
    
    @IBAction func emptyStateButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension StatsTrophiesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return core.state.statState.currentTrophies
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return TrophySectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyView
    }
    
}
