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

    func stats(for player: Player) -> [Stat] {
        let playerAtBats = atBatState.currentAtBats(for: player)
        return allPlayerStats(from: playerAtBats)
    }
    
    var currentPlayers: [Player] {
        var players = playerState.currentPlayers!
        if !statState.includeSubs {
            players = players.filter { !$0.isSub }
        }
        return players
    }
    
    var currentAtBats: [AtBat] {
        guard let currentTeam = teamState.currentTeam else { return [] }
        guard let teamAtBats = atBatState.atBats(for: currentTeam) else { return [] }
        var allAtBats = teamAtBats
        
        if !statState.includeSubs {
            allAtBats = allAtBats.filter { atBat in
                guard let atBatPlayer = playerState.player(withId: atBat.playerId) else { return false }
                return !atBatPlayer.isSub
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
        return StatType.allValues.flatMap({ type -> Stat? in
            let statValue = type.statValue(from: atBats)
            return Stat(player: player, statType: type, value: statValue)
        })
    }
    
    func allStats(ofType type: StatType, from atBats: [AtBat]) -> [Stat] {
        let playerIds = Set(atBats.map { $0.playerId })
        let players = playerIds.flatMap { playerState.player(withId: $0) }
        
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
        var allStats = isWorst ? stats.sorted() : stats.sorted().reversed()
        let winnerStat = allStats.removeFirst()
        guard winnerStat.value > 0 else { return (nil, nil) }
        guard stats.count > 1 else { return (winnerStat, nil) }

        let otherGender: Gender = winnerStat.player.gender == .male ? .female : .male
        let otherGenderStats = stats.filter { $0.player.gender == otherGender }
        let statsForSecond = currentTeam.isCoed ? otherGenderStats : allStats
        let secondStat = statsForSecond.first
        guard let second = secondStat, second.value > 0 else { return (winnerStat, nil) }
        return (first: winnerStat, second: second)
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

/**
 Generic event indicating that an object was added from Firebase and should be stored
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was added.
 - object:  The actual object that was added.
 */
 struct TeamObjectAdded<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
}

/**
 Generic event indicating that an object was changed in Firebase and should be modified
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was changed.
 - object:  The actual object that was changed.
 */
 struct TeamObjectChanged<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
}

/**
 Generic event indicating that an object was removed from Firebase and should be removed
 in the app state. The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that was removed.
 - object:  The actual object that was removed.
 */
struct TeamObjectRemoved<T>: Event {
    var teamId: String
    var object: T
    
    init(object: T, teamId: String) {
        self.object = object
        self.teamId = teamId
    }
    
}

// ERROR

/**
 Generic event indicating that an object has an error when parsing from a Firebase event.
 The event is scoped to the object type that was added.
 - Parameters:
 - T:       The type of object that produced the error
 - error:   An optional error indicating the problem that occurred
 */
struct TeamObjectErrored: Event {
    var error: Error
    
    init(error: Error) {
        self.error = error
    }
    
}

struct ErrorEvent: Event {
    var error: Error?
    var message: String?
}
