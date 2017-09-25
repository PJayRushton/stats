//
//  ContactsHelper.swift
//  Stats
//
//  Created by Parker Rushton on 6/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    
    fileprivate var spinner = UIActivityIndicatorView()
    fileprivate var originalTitle: String?
    
    
    // MARK: - Public
    
    var isLoading = false {
        didSet {
            toggleLoadingIndicator(hidden: !isLoading)
        }
    }
    
    
    // MARK: - Overrides
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.4
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalTitle = titleLabel?.text
    }
    
    private func toggleLoadingIndicator(hidden: Bool) {
        toggleButtonTitle(loading: !hidden)
        if hidden {
            isEnabled = true
            alpha = 1.0
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        } else {
            isEnabled = false
            alpha = 0.5
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            spinner.center = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
            addSubview(spinner)
            spinner.startAnimating()
        }
    }
    
    private func toggleButtonTitle(loading: Bool) {
        UIView.performWithoutAnimation {
            self.setTitle(loading ? nil : originalTitle, for: .normal)
        }
    }
    
}
