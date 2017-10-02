//
//  SeasonState.swift
//  Stats
//
//  Created by Parker Rushton on 3/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SeasonState: State {
    
    var currentSeasonId: String?
    var allSeasons = Set<Season>()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamObjectAdded<Season>:
            allSeasons.update(with: event.object)
        case let event as TeamObjectChanged<Season>:
            allSeasons.update(with: event.object)
        case let event as TeamObjectRemoved<Season>:
            allSeasons.remove(event.object)
        case let event as Selected<Season>:
            currentSeasonId = event.item?.id
        case let event as Selected<Team>:
            currentSeasonId = event.item?.currentSeasonId
        default:
            break
        }
    }
    
    
    // MARK: - Accessors
    
    var currentSeason: Season? {
        return allSeasons.first(where: { $0.id == currentSeasonId })
    }
    
    func seasons(for team: Team) -> [Season] {
        return seasons(for: team.id)
    }
    func seasons(for teamId: String) -> [Season] {
        return allSeasons.filter { $0.teamId == teamId }
    }
    
}
