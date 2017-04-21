//
//  DeleteGame.swift
//  Stats
//
//  Created by Parker Rushton on 4/21/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct DeleteGame: Command {
    
    var game: Game
    
    init(_ game: Game) {
        self.game = game
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        game.ref.removeValue()
        let atBats = state.atBatState.atBats(for: game)
        atBats.forEach { atBat in
            atBat.ref.removeValue()
        }
    }
    
}
