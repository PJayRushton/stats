//
//  Stat.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct Stat: Equatable {
    
    var player: Player
    var type: StatType
    var value: Double
    
    var displayString: String {
        switch type {
        case .battingAverage, .onBasePercentage:
            return value.displayString
        default:
            return "\(Int(value))"
        }
    }
    
}

extension Stat: Comparable { }

func <(lhs: Stat, rhs: Stat) -> Bool {
    return lhs.value < rhs.value
}

func ==(lhs: Stat, rhs: Stat) -> Bool {
    return lhs.player == rhs.player && lhs.type == rhs.type && lhs.value == rhs.value
}
