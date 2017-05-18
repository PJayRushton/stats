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
        case list = 1
        case grid
        
        var margins: CGFloat {
            return rawValue - 1
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var imageURLs: [URL] {
        return core.state.stockImageURLs
    }
    fileprivate var selectedURL: URL? {
        return core.state.newTeamState.imageURL
    }
    fileprivate let margin: CGFloat = 4.0
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate var viewMode = ViewMode.grid {
        didSet {
            guard viewMode != oldValue else { return }
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if imageURLs.isEmpty {
            core.fire(command: GetStockImages())
        }
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
        cell.imageURL = imageURLs[indexPath.item]
        return cell
    }
    
}

extension PhotoPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = imageURLs[indexPath.item]
        core.fire(event: Selected<URL>(selectedURL))
    }
    
}

extension PhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = collectionView.bounds.width
        let width = (fullWidth - (margin * viewMode.margins)) / viewMode.rawValue
        let height = width * 0.7
        return CGSize(width: width, height: height)
    }
    
}

extension PhotoPickerViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let firstIP = indexPaths.first, let lastIP = indexPaths.last else { return }
        var urls = [URL]()
        
        if firstIP == lastIP {
            urls.append(imageURLs[firstIP.item])
        } else {
            urls = Array(imageURLs[firstIP.item..<lastIP.item])
        }
        _ = ImagePrefetcher(urls: urls)
    }
    
}
