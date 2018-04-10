//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState(), middlewares: [AnalyticsMiddleware(), AppBadgeMiddleware(), MainMiddleware()])
}


struct AppState: State {
    
    var currentMenuItem: HomeMenuItem?
    var stockImageURLs = [URL]()
    
    var userState = UserState()
    var newUserState = NewUserState()
    var teamState = TeamState()
    var newTeamState = NewTeamState()
    var gameState = GameState()
    var newGameState = NewGameState()
    var seasonState = SeasonState()
    var playerState = PlayerState()
    var atBatState = AtBatState()
    var statState = StatState()
    
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<HomeMenuItem>:
            currentMenuItem = event.item
        case let event as Updated<[URL]>:
            stockImageURLs = event.payload
            
        default:
            break
        }
        
        userState.react(to: event)
        newUserState.react(to: event)
        teamState.react(to: event)
        newTeamState.react(to: event)
        gameState.react(to: event)
        newGameState.react(to: event)
        seasonState.react(to: event)
        playerState.react(to: event)
        atBatState.react(to: event)
        statState.react(to: event)
    }
    
}


// MARK: - Helpers

extension AppState {

    var hasSeenLatestStats: Bool {
        guard
            let currentUser = userState.currentUser,
            let currentTeam = teamState.currentTeam,
            let lastSeenDate = currentUser.statViewDate(forTeam: currentTeam.id),
            let seasonStats = statState.currentSeasonStats
            else { return true }
        return lastSeenDate > seasonStats.creationDate ?? Date.distantPast
    }
    var currentAtBats: [AtBat] {
        var allAtBats = atBatState.atBats
        
        if !statState.includeSubs {
            allAtBats = allAtBats.filter { atBat in
                guard let atBatPlayer = playerState.player(withId: atBat.playerId) else { return false }
                return !atBatPlayer.isSubForCurrentSeason
            }
        }
        
        if let currentGame = statState.currentGame {
            return allAtBats.filter { $0.gameId == currentGame.id }
        } else if let currentSeason = seasonState.currentSeason {
            return allAtBats.filter { $0.seasonId == currentSeason.id }
        }
        
        return allAtBats
    }
    
    fileprivate func allPlayerStats(from atBats: [AtBat]) -> [Stat] {
        guard let playerId = atBats.first?.playerId, let player = playerState.player(withId: playerId) else { return [] }
        return StatType.allValues.compactMap({ type -> Stat? in
            let statValue = type.statValue(from: atBats)
            return Stat(playerId: player.id, type: type, value: statValue)
        })
    }

}

extension Command {
    
    var networkAccess: FirebaseNetworkAccess {
        return FirebaseNetworkAccess()
    }
    
}
