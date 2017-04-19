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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBInspectable var disabledBackgroundColor: UIColor =  UIColor.lightGray.withAlphaComponent(0.5) {
        didSet {
            backgroundColor = isEnabled ? backgroundColor : disabledBackgroundColor
            setNeedsLayout()
        }
    }
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? backgroundColor : disabledBackgroundColor
        }
    }
    
}
