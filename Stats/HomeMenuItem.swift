//
//  HomeMenuItem.swift
//  St@s
//
//  Created by Parker Rushton on 2/2/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum HomeMenuItem: Int {
    case newGame
    case stats
    case games
    case roster
    case share
    
    static let allValues = [HomeMenuItem.newGame, .stats, .games, .roster, .share]
    static let fanItems = [HomeMenuItem.stats, .games, .roster, .share]
    static var managerItems: [HomeMenuItem] {
        return allValues
    }
    
    var title: String {
        switch self {
        case .newGame:
            return NSLocalizedString("New Game", comment: "")
        case .stats:
            return NSLocalizedString("St@s", comment: "")
        case .games:
            return NSLocalizedString("Games", comment: "")
        case .roster:
            return NSLocalizedString("Roster", comment: "")
        case .share:
            return NSLocalizedString("Share Team", comment: "")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .newGame:
            return #imageLiteral(resourceName: "diamond")
        case .stats:
            return #imageLiteral(resourceName: "trophy")
        case .games:
            return #imageLiteral(resourceName: "scoreboard")
        case .roster:
            return #imageLiteral(resourceName: "roster")
        case .share:
            return #imageLiteral(resourceName: "qr-code")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .newGame:
            return UIColor.flatSkyBlue
        case .stats:
            return UIColor.flatRed
        case .games:
            return UIColor.flatLimeDark
        case .roster:
            return UIColor.flatTeal
        case .share:
            return UIColor.flatCoffeeDark
        }
    }
    
    var itemsPerRow: CGFloat {
        return 1
    }
//        switch self {
//        case  .newGame:
//            return 1
//        case .stats, .games, .roster, .share:
//            return 2
//        }
//    }
    
}
