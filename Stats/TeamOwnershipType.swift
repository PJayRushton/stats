//
//  TeamOwnershipType.swift
//  Stats
//
//  Created by Parker Rushton on 9/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum TeamOwnershipType: String {
    case owned
    case managed
    case fan
    
    init(hashValue value: Int) {
        switch value {
        case 0:
            self = .owned
        case 1:
            self = .managed
        default:
            self = .fan
        }
    }
    
    var hashValue: Int {
        switch self {
        case .owned:
            return 0
        case .managed:
            return 1
        case .fan:
            return 2
        }
    }
    var firstCharacter: String {
        return String(rawValue.first!)
    }
    
    var sectionTitle: String {
        switch self {
        case .owned:
            return NSLocalizedString("Coach", comment: "")
        case .managed:
            return NSLocalizedString("St@ Keeper", comment: "")
        case .fan:
            return NSLocalizedString("Player", comment: "")
        }
    }
    
    static let allValues = [TeamOwnershipType.owned, .managed, .fan]
}
