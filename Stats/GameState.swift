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
    var allGames = Set<Game>()
    
    var teamGames: [Game] {
        guard let currentTeam = App.core.state.teamState.currentTeam else { return [] }
        return allGames.filter { $0.teamId == currentTeam.id }.sorted { $0.date > $1.date }
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
            allGames = Set(event.payload)
            if let game = currentGame, let index = event.payload.index(of: game) {
                currentGame = event.payload[index]
            }
        case let event as Updated<Game>:
            allGames.remove(event.payload)
            allGames.insert(event.payload)
        case let event as Selected<Player>:
            currentPlayer = event.item
        default:
            break
        }
    }
    
}
