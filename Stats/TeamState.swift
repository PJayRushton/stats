//
//  TeamState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct TeamState: State {
    
    var currentTeam: Team?
    var allTeams = Set<Team>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Team>:
            currentTeam = event.item
        case let event as Updated<Team>:
            allTeams.insert(event.payload)
            
            guard allTeams.count > 0 else { return }
            
            if allTeams.count == 1 {
                currentTeam = event.payload
            } else {
                currentTeam = allTeams.sorted { $0.touchDate < $1.touchDate }.first
            }
        default:
            break
        }
    }
    
}
