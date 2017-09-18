//
//  UpdateBadgeCount.swift
//  Stats
//
//  Created by Parker Rushton on 9/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct UpdateBadgeCount: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        var badgeCount = 0
        if !state.hasSeenLatestStats {
            badgeCount += 1
        }
        badgeCount += state.gameState.currentOngoingGames.count
        core.fire(event: AppBadgeUpdated(newValue: badgeCount))
    }
    
}
