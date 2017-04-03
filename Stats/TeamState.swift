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
    var isLoaded = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Team>:
            currentTeam = event.item
            isLoaded = true
        case let event as Updated<Team>:
            allTeams.insert(event.payload)
            isLoaded = true
            
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
    
    func currentUserTeams(forType type: TeamOwnershipType) -> [Team] {
        guard let currentUser = App.core.state.userState.currentUser else { return [] }
        switch type {
            case .owned:
                return allTeams.filter { currentUser.ownedTeamIds.contains($0.id) }
            case .managed:
                return allTeams.filter { currentUser.managedTeamIds.contains($0.id) }
        case .fan:
            return allTeams.filter { currentUser.fanTeamIds.contains($0.id) }
        }
    }
    
}
