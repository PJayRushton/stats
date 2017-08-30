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
    var allSeasonsDict = [String: [Season]]()
    
    var currentSeason: Season? {
        return allSeasons.first(where: { $0.id == currentSeasonId })
    }
    fileprivate var allSeasons: [Season] {
        return Array(allSeasonsDict.values.joined())
    }
    
    func seasons(for team: Team) -> [Season] {
        return allSeasonsDict[team.id] ?? []
    }
    func seasons(for teamId: String) -> [Season] {
        return allSeasonsDict[teamId] ?? []
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamEntitiesUpdated<Season>:
            allSeasonsDict[event.teamId] = event.entities
        case let event as Selected<Season>:
            currentSeasonId = event.item?.id
        case let event as Selected<Team>:
            currentSeasonId = event.item?.currentSeasonId
        default:
            break
        }
    }
    
}
