//
//  CreateGame.swift
//  Stats
//
//  Created by Parker Rushton on 4/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct NewGameReadyToShow: Event {
    var ready = true
}

struct CreateGame: Command {
    
    var game: Game
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.addObject(at: game.ref, parameters: game.jsonObject()) { result in
            switch result {
            case .success:
                core.fire(event: NewGameReadyToShow(ready: true))
                core.fire(event: Selected<Game>(self.game))
                core.fire(event: Updated<Game>(self.game))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: "Error creating game"))
            }
        }
    }
    
}
