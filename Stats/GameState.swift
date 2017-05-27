//
//  GameState.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct GameState: State {
    
    var currentPlayer: Player?
    var currentGame: Game?
    var allGamesDict = [String: [Game]]()

    // MARK: - Computed Properties
    
    var teamGames: [Game] {
        guard let currentTeam = App.core.state.teamState.currentTeam, let currentGames = allGamesDict[currentTeam.id] else { return [] }
        return currentGames.sorted { $0.date > $1.date }
    }
    
    var ongoingGames: [Game] {
        return teamGames.filter { $0.isCompleted == false }
    }

    func index(of game: Game) -> Int? {
        return teamGames.index(of: game)
    }
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Game>:
            currentGame = event.item
        case let event as Updated<[Game]>:
            guard let first = event.payload.first else {
                guard let currentTeam = App.core.state.teamState.currentTeam else { return }
                allGamesDict[currentTeam.id] = []
                currentGame = nil
                return
            }
            allGamesDict[first.teamId] = event.payload
            if let game = currentGame, let index = event.payload.index(of: game) {
                currentGame = event.payload[index]
            }
        case let event as Updated<Game>:
            let game = event.payload
            guard var teamGames = allGamesDict[game.teamId], let index = teamGames.index(of: game) else { return }
            teamGames[index] = game
            allGamesDict[game.teamId] = teamGames
        case let event as Selected<Player>:
            currentPlayer = event.item
        default:
            break
        }
    }
    
}
