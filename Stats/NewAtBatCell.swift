//
//  NewAtBatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/19/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class NewAtBatCell: UICollectionViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plusImageView.tintColor = .white
    }
    
}
