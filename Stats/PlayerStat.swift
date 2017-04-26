//
//  PlayerStat.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct Stat: Equatable {
    
    var displayName: String
    var statType: StatType
    var value: Double
    
    var displayString: String {
        switch statType {
        case .battingAverage, .onBasePercentage:
            return value.displayString
        default:
            return "\(Int(value))"
        }
    }
    
}

func ==(lhs: Stat, rhs: Stat) -> Bool {
    return lhs.displayName == rhs.displayName && lhs.statType == rhs.statType && lhs.value == rhs.value
}
