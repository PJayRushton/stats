//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState(), middlewares: [AnalyticsMiddleware()])
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

    var currentAtBats: [AtBat] {
        guard let currentTeam = teamState.currentTeam else { return [] }
        guard let teamAtBats = atBatState.atBats(for: currentTeam) else { return [] }
        var allAtBats = teamAtBats
        
        if let currentSeason = seasonState.currentSeason {
            allAtBats = allAtBats.filter { $0.seasonId == currentSeason.id }
        }
        
        if case let currentGames = statState.currentGames, !currentGames.isEmpty {
            let gameIds = currentGames.map { $0.id }
            allAtBats = allAtBats.filter { gameIds.contains($0.gameId) }
        }
        
        if !statState.includeSubs {
            allAtBats = allAtBats.filter { atBat in
                guard let atBatPlayer = playerState.player(withId: atBat.playerId) else { return false }
                return !atBatPlayer.isSub
            }
        }
        
        return allAtBats
    }
    
    
    func allStats(ofType type: StatType, from atBats: [AtBat]) -> [Stat] {
        let playerIds = Set(atBats.map { $0.playerId })
        let players  = playerIds.flatMap { playerState.player(withId: $0) }
        
        var playerStats = [Stat]()
        
        players.forEach { player in
            let playerAtBats = atBats.filter { $0.playerId == player.id }
            let statValue = type.statValue(from: playerAtBats)
            let playerStat = Stat(player: player, statType: type, value: statValue)
            playerStats.append(playerStat)
        }
        
        return playerStats.sorted(by: statState.sortType.sort)
    }
    
    var currentTrophySections: [TrophySection] {
        return Trophy.allValues.flatMap { trophy -> TrophySection? in
            let trophyStats = allStats(ofType: trophy.statType, from: currentAtBats)
            let isWorst = trophy == Trophy.worseBattingAverage
            let winners = winningStats(from: trophyStats, isWorst: isWorst)
            guard let winner = winners.first else { return nil }
            
            return TrophySection(trophy: trophy, firstStat: winner, secondStat: winners.second)
        }
    }
    
    private func winningStats(from stats: [Stat], isWorst: Bool = false) -> (first: Stat?, second: Stat?) {
        guard !stats.isEmpty, let currentTeam = teamState.currentTeam else { return (nil, nil) }
        var allStats = stats.sorted(by: { $0.value > $1.value })
        let winnerStat = isWorst ? allStats.removeLast() : allStats.removeFirst()
        guard stats.count > 1 else { return (winnerStat, nil) }

        let otherGender: Gender = winnerStat.player.gender == .male ? .female : .male
        let otherGenderStats = stats.filter { $0.player.gender == otherGender }
        let statsForSecond = currentTeam.isCoed ? otherGenderStats : allStats
        let secondStat = isWorst ? statsForSecond.last : statsForSecond.first
        return (first: winnerStat, second: secondStat)
    }

}

extension Command {
    
    var networkAccess: FirebaseNetworkAccess {
        return FirebaseNetworkAccess()
    }
    
}


// MARK: - Events

// GENERIC

struct Selected<T>: Event {
    var item: T?
    
    init(_ item: T?) {
        self.item = item
    }
    
}

struct Updated<T>: Event {
    var payload: T
    
    init(_ payload: T) {
        self.payload = payload
    }
    
}


struct TeamEntitiesUpdated<T>: Event {
    var teamId: String
    var entities: [T]
}

// ERROR

struct ErrorEvent: Event {
    var error: Error?
    var message: String?
}
