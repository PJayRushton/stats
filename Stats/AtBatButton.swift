//
//  AtBatButton.swift
//  Stats
//
//  Created by Parker Rushton on 4/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class AtBatButton: UIButton {
    
    var code: AtBatCode! {
        didSet {
            setImage(code.image, for: .normal)
            setImage(code.selectedImage, for: .selected)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView?.tintColor = isSelected ? tintColor : UIColor.flatBlack
        }
    }
    
}
