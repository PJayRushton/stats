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
    var isSubscribed = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Team>:
            currentTeam = event.item
            isSubscribed = true
            
            if let selectedTeam = event.item {
                UserDefaults.standard.lastUsedTeamId = selectedTeam.id
            }
        case let event as Updated<Team>:
            allTeams.remove(event.payload)
            allTeams.insert(event.payload)
            isSubscribed = true
            
            if event.payload == currentTeam {
                currentTeam = event.payload
            }
            if let lastUsedId = UserDefaults.standard.lastUsedTeamId, event.payload.id == lastUsedId {
                currentTeam = event.payload
            }
            if let currentUser = App.core.state.userState.currentUser, allTeams.count == currentUser.allTeamIds.count, currentTeam == nil { // Data migration. Switched from using touch date to defaults. First launch didn't select a team.
                currentTeam = event.payload
            }
        case _ as Subscribed<Team>:
            isSubscribed = true
        case let event as Delete<Team>:
            allTeams.remove(event.object)
            
            if currentTeam == event.object {
                currentTeam = nil
                
                if let first = allTeams.first {
                    currentTeam = first
                }
            }
        default:
            break
        }
    }
    
    func currentUserTeams(forType type: TeamOwnershipType) -> [Team] {
        guard let currentUser = App.core.state.userState.currentUser else { return [] }
        switch type {
        case .owned:
            return allTeams.filter { currentUser.ownedTeamIds.contains($0.id) }.sorted(by: { $0.name < $1.name })
        case .managed:
            return allTeams.filter { currentUser.managedTeamIds.contains($0.id) }.sorted(by: { $0.name < $1.name })
        case .fan:
            return allTeams.filter { currentUser.fanTeamIds.contains($0.id) }.sorted(by: { $0.name < $1.name })
        }
    }
    
}

extension UserDefaults {
    
    var lastUsedTeamId: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            synchronize()
        }
    }
    
}
