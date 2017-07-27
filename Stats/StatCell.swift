//
//  StatCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import SpreadsheetView

class StatCell: Cell, AutoReuseIdentifiable {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = bounds
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update(with title: String, alignment: NSTextAlignment = .left, fontSize: CGFloat = 17) {
        titleLabel.text = title
        titleLabel.textAlignment = alignment
        titleLabel.font = FontType.lemonMilk.font(withSize: fontSize)
    }
    
    func update(with stat: Stat, alignment: NSTextAlignment = .center, fontSize: CGFloat = 17) {
        titleLabel.text = stat.displayString
        titleLabel.textAlignment = alignment
        titleLabel.font = FontType.lemonMilk.font(withSize: fontSize)
    }
    
}
