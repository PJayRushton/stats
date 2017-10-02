//
//  UnsubscribeFromAtBats.swift
//  Stats
//
//  Created by Parker Rushton on 9/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct UnsubscribeFromAtBats: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let team = state.teamState.currentTeam, let seasonId = team.currentSeasonId else { return }
        core.fire(event: ClearAtBats())
        let atBatRef = StatsRefs.atBatsRef(teamId: team.id)
        let query = atBatRef.queryOrdered(byChild: seasonIdKey).queryEqual(toValue: seasonId)
        networkAccess.unsubscribe(from: query)
    }

}
