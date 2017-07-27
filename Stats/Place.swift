//
//  Place.swift
//  Stats
//
//  Created by Parker Rushton on 7/6/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum Place: Int {
    case first
    case second
    case third
    
    var emoji: String {
        switch self {
        case .first:
            return "🥇"
        case .second:
            return "🥈"
        case .third:
            return "🥉"
        }
    }
    
    var color: UIColor {
        switch self {
        case .first:
            return UIColor.flatYellow.withAlphaComponent(0.1)
        case .second:
            return UIColor.flatGray.withAlphaComponent(0.1)
        case .third:
            return UIColor.flatBrown.withAlphaComponent(0.1)
        }
    }
    
}
