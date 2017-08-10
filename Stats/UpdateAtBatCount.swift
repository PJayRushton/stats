//
//  UpdateAtBatCount.swift
//  Stats
//
//  Created by Parker Rushton on 7/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct UpdateAtBatCount: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let currentTeam = state.teamState.currentTeam, let currentSeasonId = currentTeam.currentSeasonId else { return }
        let atBatsQuery = StatsRefs.atBatsRef(teamId: currentTeam.id).queryOrdered(byChild: seasonIdKey).queryEqual(toValue: currentSeasonId)
        networkAccess.getKeys(at: atBatsQuery) { result in
            if case let .success(keys) = result {
                core.fire(event: AtBatCountUpdated(count: keys.count))
            }
        }
    }
    
}
