//
//  PhotoCell.swift
//  Stats
//
//  Created by Parker Rushton on 5/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkView: UIView!
    
    override var isSelected: Bool {
        didSet {
            checkView.isHidden = !isSelected
        }
    }
    
    var imageURL: URL? {
        didSet {
            imageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "picture"))
        }
    }
    
}
