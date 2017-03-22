//
//  HomeMenuItem.swift
//  St@s
//
//  Created by Parker Rushton on 2/2/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import ChameleonFramework

enum HomeMenuItem: Int {
    case newGame
    case stats
    case games
    case roster
    case share
    
    static let allValues = [HomeMenuItem.newGame, .stats, .games, .roster, .share]
    
    var title: String {
        switch self {
        case .newGame:
            return NSLocalizedString("New Game", comment: "")
        case .stats:
            return NSLocalizedString("St@ts", comment: "")
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
            return UIImage(named: "")
        case .stats:
            return UIImage(named: "")
        case .games:
            return UIImage(named: "")
        case .roster:
            return UIImage(named: "")
        case .share:
            return UIImage(named: "")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .newGame:
            return UIColor.flatBlue
        case .stats:
            return UIColor.flatRed
        case .games:
            return UIColor.flatYellow
        case .roster:
            return UIColor.flatTeal
        case .share:
            return UIColor.flatGreen
        }
    }
    
    var itemsPerRow: CGFloat {
        switch self {
        case  .newGame:
            return 1
        case .stats, .games, .roster, .share:
            return 2
        }
    }
    
}
