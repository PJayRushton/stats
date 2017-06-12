//
//  StatState.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubFilterUpdated: Event {
    var includeSubs: Bool
}

struct StatState: State {
    
    var currentViewType = StatsViewType.trophies
    var currentStatType = StatType.battingAverage
    var includeSubs = false
    var currentGames = [Game]()
    var currentSeasonId: String?
    var sortType = SortType.best
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<StatsViewType>:
            currentViewType = event.payload
        case let event as Updated<StatType>:
            currentStatType = event.payload
        case let event as SubFilterUpdated:
            includeSubs = event.includeSubs
        case let event as Updated<SortType>:
            sortType = event.payload
        case let event as Selected<[Game]>:
            currentGames = event.item ?? []
        case let event as Selected<Season>:
            currentSeasonId = event.item?.id
        case let event as Selected<Team>:
            guard let _ = event.item else { return }
            currentGames = []
            currentSeasonId = event.item?.currentSeasonId
        default:
            break
        }
    }
    
}
