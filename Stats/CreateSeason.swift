//
//  CreateSeason.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct CreateSeason: Command {
    
    var name: String
    var teamId: String
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.seasonsRef(teamId: teamId).childByAutoId()
        let season = Season(id: ref.key, isCompleted: false, name: name, teamId: teamId)
        networkAccess.updateObject(at: ref, parameters: season.marshaled()) { result in
            switch result {
            case .success:
                core.fire(event: Updated<Season>(season))
                core.fire(event: Selected<Season>(season))
                self.setSeasonAsCurrent(season, core: core)
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: "Error saving season"))
            }
        }
    }
    
    private func setSeasonAsCurrent(_ season: Season, core: Core<AppState>) {
        guard var currentTeam = core.state.teamState.currentTeam else { return }
        currentTeam.currentSeasonId = season.id
        core.fire(command: UpdateObject(currentTeam))
    }
    
}
