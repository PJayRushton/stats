//
//  GameState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct GameState: State {
    
    var currentPlayerId: String?
    var currentGameId: String?
    var allGames = Set<Game>()
    var recentlyCompletedGame: Game?
    var processedGames: CalendarGames?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as TeamObjectAdded<Game>:
            allGames.update(with: event.object)
        case let event as TeamObjectChanged<Game>:
            allGames.update(with: event.object)
        case let event as TeamObjectRemoved<Game>:
            allGames.remove(event.object)
            
        case let event as Selected<Game>:
            currentGameId = event.item?.id
            
        case let event as Updated<Game>:
            allGames.update(with: event.payload)
        case let event as Updated<CalendarGames>:
            processedGames = event.payload
        case let event as Selected<Player>:
            currentPlayerId = event.item?.id
        case let event as UpdateRecentlyCompletedGame:
            recentlyCompletedGame = event.game
            
        default:
            break
        }
    }
    
    
    // MARK: - Helpers
    var currentGame: Game? {
        guard let currentGameId = currentGameId else { return nil }
        return allGames.first(where: { $0.id == currentGameId })
    }
    var currentPlayer: Player? {
        guard let id = currentPlayerId else { return nil }
        return App.core.state.playerState.player(withId: id)
    }
    
    /// All games of the current team regardless of season
    var teamGames: [Game] {
        guard let currentTeamId = App.core.state.teamState.currentTeamId else { return [] }
        let games = allGames.filter { $0.teamId == currentTeamId }
        return games.sorted(by: >)
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
    
    func order(of game: Game) -> Int? {
        return teamGames.sorted().index(of: game)
    }
    
    func index(of game: Game) -> Int? {
        return teamGames.index(of: game)
    }
    
    func games(of season: Season) -> [Game] {
        return allGames.filter { $0.seasonId == season.id }.sorted(by: >)
    }
    
    func game(withId id: String) -> Game? {
        return teamGames.first(where: { $0.id == id})
    }
    
}
