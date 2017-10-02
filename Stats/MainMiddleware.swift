//
//  MainMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 8/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct MainMiddleware: Middleware {
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as ICloudUserLoaded:
            guard let id = event.id else { return }
            App.core.fire(command: GetCurrentUser(iCloudId: id))
            
        case let event as Updated<Team>:
            if event.payload.id == state.teamState.currentTeamId {
                App.core.fire(event: Selected<Team>(event.payload))
            }
            
        case let event as TeamObjectAdded<GameStats>:
            guard event.object.isSeason && event.object.gameId == state.seasonState.currentSeasonId else { return }
            App.core.fire(command: UpdateTrophies())
            
        case let event as TeamObjectChanged<GameStats>:
            guard event.object.isSeason && event.object.gameId == state.seasonState.currentSeasonId else { return }
            App.core.fire(command: UpdateTrophies())
            
        case let event as TeamObjectAdded<AtBat>:
            print("👉\(state.atBatState.atBats.count)")

        default:
            break
        }
    }
    
}
