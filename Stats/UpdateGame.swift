//
//  UpdateGame.swift
//  Stats
//
//  Created by Parker Rushton on 8/17/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct UpdateGame: Command {
    
    var game: Game
    var calendarId: String?
    
    init(_ game: Game, calendarId: String?) {
        self.game = game
        self.calendarId = calendarId
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        var updatedGame = game
        updatedGame.calendarId = calendarId
        core.fire(command: UpdateObject(updatedGame))
    }
    
}
