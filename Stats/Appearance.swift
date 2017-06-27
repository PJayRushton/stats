//
//  Appearance.swift
//  Stats
//
//  Created by Parker Rushton on 4/1/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum Appearance {
    
    static let backButtonImage = #imageLiteral(resourceName: "leftChevronWhite").withRenderingMode(.alwaysTemplate)
    
    static func setUp(navTextColor: UIColor = UIColor.white) {
        let navTitleAttributes = [NSFontAttributeName: FontType.lemonMilk.font(withSize: 20), NSForegroundColorAttributeName: navTextColor]
        UINavigationBar.appearance().titleTextAttributes = navTitleAttributes
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).tintColor = navTextColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: FontType.lemonMilk.font(withSize: 15)], for: .normal)
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarStyle = .lightContent
//        
//        for family in UIFont.familyNames.sorted() {
//            print("\(family)")
//            for names in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
    }
    
}

enum FontType: String {
    case lemonMilk = "Lemon/Milk"
    case jersey = "SportsWorld"
    case scoreboard = "ScoreBoard"
    
    func font(withSize size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
}
