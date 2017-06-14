//
//  BasicHeaderCell.swift
//  Stats
//
//  Created by Parker Rushton on 4/1/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class BasicHeaderCell: UITableViewCell, AutoReuseIdentifiable {
    
    @IBOutlet weak var label: UILabel!
    
    func update(with text: String, backgroundColor: UIColor = .secondaryAppColor, alignment: NSTextAlignment = .left, fontSize: CGFloat = 16) {
        label.text = text
        label.textColor = .white
        label.textAlignment = alignment
        label.font = FontType.lemonMilk.font(withSize: fontSize)
        contentView.backgroundColor = backgroundColor
    }
    
}
