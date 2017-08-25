//
//  Stat.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct Stat {
    
    var playerId: String
    var type: StatType
    var value: Double
    
    init(playerId: String, type: StatType, value: Double) {
        self.playerId = playerId
        self.type = type
        self.value = value
    }
    var player: Player? {
        return App.core.state.playerState.player(withId: playerId)
    }
    
    var displayString: String {
        switch type {
        case .battingAverage, .onBasePercentage:
            return value.displayString
        default:
            return "\(Int(value))"
        }
    }
    
}

extension Stat: Equatable { }

func ==(lhs: Stat, rhs: Stat) -> Bool {
    return lhs.playerId == rhs.playerId && lhs.type == rhs.type && lhs.value == rhs.value
}


extension Stat: Comparable { }

func <(lhs: Stat, rhs: Stat) -> Bool {
    return lhs.value < rhs.value
}
