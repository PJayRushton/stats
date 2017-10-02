//
//  SubscribeToAtBats.swift
//  Stats
//
//  Created by Parker Rushton on 8/8/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscribeToAtBats: Command {
    
    var teamId: String
    var newSeasonId: String
    var previousSeasonId: String?
    
    init(of teamId: String, newSeasonId: String, previousSeasonId: String? = nil) {
        self.teamId = teamId
        self.newSeasonId = newSeasonId
        self.previousSeasonId = previousSeasonId
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let atBatRef = StatsRefs.atBatsRef(teamId: teamId)
        
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
                    core.fire(event: TeamObjectAdded<AtBat>(object: atBat, teamId: self.teamId))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<AtBat>(object: atBat, teamId: self.teamId))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<AtBat>(object: atBat, teamId: self.teamId))
                default:
                    fatalError()
                }
            case let .failure(error):
                core.fire(event: TeamObjectErrored(error: error))
            }
        }
    }

}
