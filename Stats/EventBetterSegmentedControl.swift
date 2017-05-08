//
//  EventBetterSegmentedControl.swift
//  Stats
//
//  Created by Parker Rushton on 4/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import BetterSegmentedControl

extension BetterSegmentedControl {
    
    func setUp(with titles: [String], indicatorColor: UIColor = UIColor.secondaryAppColor, fontSize: CGFloat = 14) {
        self.titles = titles
        titleFont = FontType.lemonMilk.font(withSize: fontSize)
        selectedTitleFont = FontType.lemonMilk.font(withSize: fontSize + 2)
        titleColor = .gray400
        selectedTitleColor = .white
        indicatorViewBackgroundColor = indicatorColor
        cornerRadius = 5
    }
    
}
