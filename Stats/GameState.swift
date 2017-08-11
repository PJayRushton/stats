//
//  GameState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
struct UpdateRecentlyCompletedGame: Event {
    var game: Game?
}

struct GameState: State {
    
    var currentPlayer: Player?
    var currentGame: Game?
    var allGamesDict = [String: [Game]]()
    var recentlyCompletedGame: Game?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Game>:
            currentGame = event.item
        case let event as TeamEntitiesUpdated<Game>:
            allGamesDict[event.teamId] = event.entities
            
            if let game = currentGame, let index = event.entities.index(of: game) {
                currentGame = event.entities[index]
            }
        case let event as Updated<Game>:
            let game = event.payload
            guard var teamGames = allGamesDict[game.teamId], let index = teamGames.index(of: game) else { return }
            teamGames[index] = game
            allGamesDict[game.teamId] = teamGames
        case let event as Selected<Player>:
            currentPlayer = event.item
        case let event as UpdateRecentlyCompletedGame:
            recentlyCompletedGame = event.game
        default:
            break
        }
    }
    
    
    // MARK: - Helpers
    
    /// All games of the current team regardless of season
    var teamGames: [Game] {
        guard let currentTeam = App.core.state.teamState.currentTeam, let currentGames = allGamesDict[currentTeam.id] else { return [] }
        return currentGames.sorted(by: >)
    }
    
    /// Games of the current team scoped to the current season
    var currentGames: [Game] {
        return teamGames.filter { $0.seasonId == App.core.state.seasonState.currentSeason?.id }

    }
    
    /// Games of the current team scoped to the current seasons that are net yet completed
    var currentOngoingGames: [Game] {
        let seasonGames = teamGames.filter { $0.seasonId == App.core.state.seasonState.currentSeason?.id }
        return seasonGames.filter { $0.isCompleted == false }.sorted(by: >)
    }


    /// Games of the current team
    ///
    /// - Parameter regularSeason: `true` -> completed regular season games; `false` completed post season games
    /// - Returns: an array of games from either the regular or post season
    func currentGames(regularSeason: Bool) -> [Game] {
        let seasonGames = teamGames.filter { $0.seasonId == App.core.state.seasonState.currentSeason?.id }
        return seasonGames.filter { $0.isRegularSeason == regularSeason && $0.isCompleted == true }.sorted(by: >)
    }
    
    
    func index(of game: Game) -> Int? {
        return teamGames.index(of: game)
    }
    
    func games(of season: Season) -> [Game] {
        guard let gamesOfTeam = allGamesDict[season.teamId] else { return [] }
        return gamesOfTeam.filter { $0.seasonId == season.id }.sorted(by: >)
    }
    
}
