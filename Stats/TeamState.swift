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
        default:
            break
        }
    }
    
}
