//
//  HomeViewController.swift
//  St@s
//
//  Created by Parker Rushton on 1/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr

class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: - Properties
    
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    fileprivate let margin: CGFloat = 0
    
    var core = App.core
    
    var isPresentingOnboarding = false
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        
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
    
}


// MARK: - Subscriber

extension HomeViewController: Subscriber {
    
    func update(with state: AppState) {
        if state.userState.currentUser == nil && !isPresentingOnboarding {
            isPresentingOnboarding = true
            let usernameVC = UsernameViewController.initializeFromStoryboard().embededInNavigationController
            present(usernameVC, animated: true, completion: nil)
        }
    }
    
}


// MARK: - CollectionView
// MARK: DataSource

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeMenuItem.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        let menuItem = HomeMenuItem.allValues[indexPath.row]
        cell.update(with: menuItem)
        
        return cell
    }
    
}


// MARK: Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedbackGenerator.selectionChanged()
        guard let menuItem = HomeMenuItem(rawValue: indexPath.row) else { return }
        switch menuItem {
        case .newGame:
            break
        case .stats:
            break
        case .games:
            break
        case .roster:
            break
        case .share:
            break
        }
    }
    
}


// MARK: FlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let menuItem = HomeMenuItem(rawValue: indexPath.row) else { return CGSize.zero }
        let rows = CGFloat(HomeMenuItem.allValues.filter { $0.itemsPerRow == 1 }.count + HomeMenuItem.allValues.filter { $0.itemsPerRow == 2 }.count / 2)
        let height = (collectionView.bounds.size.height - (margin * rows)) / rows
        let width = (collectionView.bounds.size.width - (margin * (menuItem.itemsPerRow - 1))) / menuItem.itemsPerRow
        
        return CGSize(width: width, height: height)
    }
    
}
