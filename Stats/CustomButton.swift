//
//  CustomButton.swift
//  Stats
//
//  Created by Parker Rushton on 4/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        originalBackgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        originalBackgroundColor = backgroundColor
    }
    
    var originalBackgroundColor: UIColor? = UIColor.flatLimeDark
    
    @IBInspectable var disabledBackgroundColor: UIColor =  UIColor.flatLimeDark.withAlphaComponent(0.5) {
        didSet {
            backgroundColor = isEnabled ? originalBackgroundColor : disabledBackgroundColor
            setNeedsLayout()
        }
    }
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? originalBackgroundColor : disabledBackgroundColor
            setNeedsLayout()
        }
    }
    
}
