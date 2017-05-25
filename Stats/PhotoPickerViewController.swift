//
//  PhotoPickerViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoPickerViewController: Component, AutoStoryboardInitializable {
    
    enum ViewMode: CGFloat {
        case list
        case grid
        
        var numberOfMargins: CGFloat {
            return rawValue
        }
        var columns: CGFloat {
            return rawValue + 1
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate let margin: CGFloat = 1.0
    fileprivate var gridBarButton: UIBarButtonItem?
    fileprivate var linesBarButton: UIBarButtonItem?

    fileprivate var imageURLs: [URL] {
        return core.state.stockImageURLs
    }
    fileprivate var selectedURL: URL? {
        return core.state.newTeamState.imageURL
    }
    fileprivate var viewMode = ViewMode.list {
        didSet {
            guard viewMode != oldValue else { return }
            navigationItem.rightBarButtonItem = viewMode == .grid ? gridBarButton : linesBarButton
            collectionView.performBatchUpdates({ 
                self.collectionView.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "grid"), style: .plain, target: self, action: #selector(flipLayout(_:)))
        linesBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "lines"), style: .plain, target: self, action: #selector(flipLayout(_:)))
        
        _ = ImagePrefetcher(urls: imageURLs)

        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = false
        
        if imageURLs.isEmpty {
            core.fire(command: GetStockImages())
        }
        viewMode = .grid
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    override func update(with state: AppState) {
        collectionView.reloadData()
    }
    
    func flipLayout(_ sender: UIBarButtonItem) {
        viewMode = viewMode == .grid ? .list : .grid
    }
    
}

extension PhotoPickerViewController {
    
}


// MARK: - CollectionView

extension PhotoPickerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        let imageURL = imageURLs[indexPath.item]
        cell.imageURL = imageURL
        cell.isSelected = core.state.newTeamState.imageURL == imageURL
        
        return cell
    }
    
}

extension PhotoPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = imageURLs[indexPath.item]
        if let alreadySelectedURL = core.state.newTeamState.imageURL, alreadySelectedURL == selectedURL {
            core.fire(event: Selected<URL>(nil))
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            core.fire(event: Selected<URL>(selectedURL))
        }
    }
    
}

extension PhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = collectionView.bounds.width
        let width = (fullWidth - (margin * viewMode.numberOfMargins)) / viewMode.columns
        let height = width * 0.7
        return CGSize(width: width, height: height)
    }
    
}
