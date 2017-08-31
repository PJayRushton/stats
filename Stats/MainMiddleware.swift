//
//  MainMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 8/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct MainMiddleware: Middleware {
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as TeamObjectAdded<GameStats>:
            if event.object.isSeason && event.object.gameId == state.seasonState.currentSeasonId {
                App.core.fire(command: UpdateTrophies())
            }
        case let event as TeamObjectChanged<GameStats>:
            if event.object.isSeason && event.object.gameId == state.seasonState.currentSeasonId {
                App.core.fire(command: UpdateTrophies())
            }

        default:
            break
        }
    }
    
}
