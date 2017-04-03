//
//  Appearance.swift
//  Stats
//
//  Created by Parker Rushton on 4/1/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import ChameleonFramework

enum Appearance {
    
    static func setUp() {
        let navTitleAttributes = [NSFontAttributeName: FontType.lemonMilk.font(withSize: 20), NSForegroundColorAttributeName: UIColor.gray500]
        UINavigationBar.appearance().titleTextAttributes = navTitleAttributes
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).tintColor = UIColor.gray500
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: FontType.lemonMilk.font(withSize: 15)], for: .normal)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.flatBlue
    }
    
}

enum FontType: String {
    case lemonMilk = "Lemon/Milk"
    
    func font(withSize size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
}
