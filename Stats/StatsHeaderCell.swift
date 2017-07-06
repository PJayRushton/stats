//
//  StatsHeaderCell.swift
//  Stats
//
//  Created by Parker Rushton on 7/6/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class StatsHeaderCell: UICollectionReusableView, AutoReuseIdentifiable {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    func update(with text: String, backgroundColor: UIColor) {
        colorView.backgroundColor = backgroundColor
        textLabel.text = text
    }
    
}
