//
//  SaveGameStats.swift
//  Stats
//
//  Created by Parker Rushton on 8/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveGameStats: Command {
    
    var game: Game
    
    init(for game: Game) {
        self.game = game
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        var stats = gameStats(from: game, state: state)
        let ref = StatsRefs.gameStatsRef(teamId: stats.teamId).childByAutoId()
        stats.id = ref.key
        networkAccess.setValue(at: ref, parameters: stats.jsonObject())
    }
    
    func gameStats(from game: Game, state: AppState) -> GameStats {
        var gameStats = GameStats(game)
        var stats = [String: [Stat]]()
        game.lineup.forEach { player in
            stats[player.id] = state.statState.playerStats(for: player, game: game)
        }
        gameStats.stats = stats
        
        return gameStats
    }

}
