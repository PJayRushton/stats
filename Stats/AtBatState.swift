//
//  AtBatState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct AtBatState: State {
    
    var currentAtBat: AtBat?
    var allAtBats = Set<AtBat>()
    
    var currentResult: AtBatCode? = .single
    
    func atBats(for player: Player) -> [AtBat] {
        return allAtBats.filter { $0.playerId == player.id }.sorted { $0.order > $1.order }
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<AtBat>:
            currentAtBat = event.item
        case let event as Updated<[AtBat]>:
            allAtBats = Set(event.payload)
        case let event as Selected<AtBatCode>:
            currentResult = event.item
        default:
            break
        }
    }
    
}
