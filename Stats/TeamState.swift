//
//  TeamState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct TeamState: State {
    
    var allTeams = Set<Team>()
    var isSubscribed = false
    var currentTeamId: String? {
        didSet {
            guard let newTeamId = currentTeamId else { return }
            if newTeamId != oldValue, let team = team(withId: newTeamId), let seasonId = team.currentSeasonId {
                App.core.fire(command: SubscribeToAtBats(of: newTeamId, newSeasonId: seasonId))
            }
        }
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<User>:
            currentTeamId = event.item?.currentTeamId
            
        case let event as Selected<Team>:
            currentTeamId = event.item?.id
            isSubscribed = true
            
        case let event as Updated<Team>:
            allTeams.update(with: event.payload)
            isSubscribed = true
            
        case _ as Subscribed<Team>:
            isSubscribed = true
            
        case let event as Delete<Team>:
            allTeams.remove(event.object)
            currentTeamId = allTeams.first?.id
            
        default:
            break
        }
    }
    
    
    // MARK: - Accessors
    
    var currentTeam: Team? {
        guard let currentTeamId = currentTeamId else { return nil }
        return allTeams.first(where: { $0.id == currentTeamId })
    }
    
    func team(withId id: String) -> Team? {
        return allTeams.first(where: { $0.id == id })
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
