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
        guard let currentTeam = state.teamState.currentTeam else { return }
        let atBatsRef = StatsRefs.atBatsRef(teamId: currentTeam.id)
        networkAccess.getKeys(at: atBatsRef) { result in
            if case let .success(keys) = result {
                core.fire(event: AtBatCountUpdated(count: keys.count))
            }
        }
    }
    
}
