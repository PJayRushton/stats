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
    
    func update(with backgroundColor: UIColor = .white, text: String, alignment: NSTextAlignment) {
        label.text = text
        label.textAlignment = alignment
    }
    
}
