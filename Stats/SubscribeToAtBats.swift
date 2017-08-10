//
//  SubscribeToAtBats.swift
//  Stats
//
//  Created by Parker Rushton on 8/8/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscribeToAtBats: Command {
    
    var team: Team
    var newSeasonId: String
    var previousSeasonId: String?
    
    init(of team: Team, newSeasonId: String, previousSeasonId: String? = nil) {
        self.team = team
        self.newSeasonId = newSeasonId
        self.previousSeasonId = previousSeasonId
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        core.fire(event: ClearAtBats())
        core.fire(command: UpdateAtBatCount())
        let atBatRef = StatsRefs.atBatsRef(teamId: team.id)
        
        if let oldSeason = previousSeasonId {
            atBatRef.queryOrdered(byChild: seasonIdKey).queryEqual(toValue: oldSeason).removeAllObservers()
        }
        
        let query = atBatRef.queryOrdered(byChild: seasonIdKey).queryEqual(toValue: newSeasonId)
        networkAccess.fullySubscribe(to: query) { result, eventType in
            let atBatResult = result.map(AtBat.init)
            
            switch atBatResult {
            case let .success(atBat):
                switch eventType {
                case .childAdded:
                    core.fire(event: TeamObjectAdded<AtBat>(object: atBat, teamId: self.team.id))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<AtBat>(object: atBat, teamId: self.team.id))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<AtBat>(object: atBat, teamId: self.team.id))
                default:
                    fatalError()
                }
            case let .failure(error):
                core.fire(event: TeamObjectErrored(error: error))
            }
        }
    }

}
