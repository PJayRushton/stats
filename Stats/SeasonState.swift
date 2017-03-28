//
//  SeasonState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

struct SeasonState: State {
    
    var currentSeason: Season?
    var allSeasons = Set<Season>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Season>:
            currentSeason = event.item
        case let event as Updated<Season>:
            allSeasons.insert(event.payload)
        default:
            break
        }
    }
    
}
