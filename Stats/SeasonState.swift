//
//  SeasonState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SeasonState: State {
    
    var currentSeason: Season?
    var allSeasonsDict = [String: [Season]]()
    
    func seasons(for team: Team) -> [Season] {
        return allSeasonsDict[team.id] ?? []
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Season>:
            currentSeason = event.item
        case let event as Updated<[Season]>:
            guard let first = event.payload.first else { return }
            allSeasonsDict[first.teamId] = event.payload
            
            if let season = currentSeason, let index = event.payload.index(of: season) {
                currentSeason = event.payload[index]
            }
        default:
            break
        }
    }
    
}
