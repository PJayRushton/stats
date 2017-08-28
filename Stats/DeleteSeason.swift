//
//  DeleteSeason.swift
//  Stats
//
//  Created by Parker Rushton on 5/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct DeleteSeason: Command {
    
    var season: Season
    
    init(_ season: Season) {
        self.season = season
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.deleteObject(at: season.ref) { result in
            if case .success = result {
                self.deleteGames(core)
                self.deleteAtBats(core)
                self.deleteFromPlayers(core)
            }
        }
    }
    
    func deleteGames(_ core: Core<AppState>) {
        let gamesToDelete = core.state.gameState.games(of: season)
        gamesToDelete.forEach( { core.fire(command: DeleteGame($0)) })
    }
    
    func deleteAtBats(_ core: Core<AppState>) {
        let atBatsToDelete = core.state.atBatState.atBats.filter { $0.seasonId == season.id }
        atBatsToDelete.forEach { core.fire(command: DeleteObject($0)) }
    }
    
    func deleteFromPlayers(_ core: Core<AppState>) {
        let players = core.state.playerState.players(for: season.teamId)
        players.forEach { player in
            var updatedPlayer = player
            updatedPlayer.seasons[seasonId] = nil
            core.fire(command: SetObject(updatedPlayer))
        }
    }
    
}
