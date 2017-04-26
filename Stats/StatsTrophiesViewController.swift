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
    
    @IBOutlet weak var collectionView: IGListCollectionView!

    fileprivate lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

}

extension StatsTrophiesViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [] // FIXME:
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return IGListSectionController() // FIXME:
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
}
