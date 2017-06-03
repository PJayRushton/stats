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
                self.deleteGames(core: core)
            }
        }
    }
    
    func deleteGames(core: Core<AppState>) {
        let gamesToDelete = core.state.gameState.games(of: season)
        gamesToDelete.forEach( { core.fire(command: DeleteGame($0)) })
    }
    
}
