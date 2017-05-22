//
//  SubscribeToTeam.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct SubscribeToTeam: Command {
    
    var teamId: String
    
    init(withId id: String) {
        self.teamId = id
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        subscribeToTeam(core: core)
        subscribeToSeasons(core: core)
        subscribeToPlayers(core: core)
        subscribeToGames(core: core)
        subscribeToAtBats(core: core)
    }
    
    private func subscribeToTeam(core: Core<AppState>) {
        let ref = StatsRefs.teamsRef.child(teamId)
        
        networkAccess.subscribe(to: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                core.fire(event: Updated<Team>(team))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToSeasons(core: Core<AppState>) {
        let ref = StatsRefs.seasonsRef(teamId: self.teamId)
        networkAccess.subscribe(to: ref) { result in
            let seasonsResult = result.map { (json: JSONObject) -> [Season] in
                return json.parsedObjects()
            }
            
            switch seasonsResult {
            case let .success(seasons):
                core.fire(event: Updated<[Season]>(seasons))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }

    private func subscribeToPlayers(core: Core<AppState>) {
        networkAccess.subscribe(to: StatsRefs.playersRef(teamId: self.teamId)) { result in
            let playersResult = result.map { (json: JSONObject) -> [Player] in
                return json.parsedObjects()
            }

            switch playersResult {
            case let .success(players):
                core.fire(event: Updated<[Player]>(players))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToGames(core: Core<AppState>) {
        networkAccess.subscribe(to: StatsRefs.gamesRef(teamId: self.teamId)) { result in
            let gamesResult = result.map { (json: JSONObject) -> [Game] in
                return json.parsedObjects()
            }
            
            switch gamesResult {
            case let .success(games):
                core.fire(event: Updated<[Game]>(games))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToAtBats(core: Core<AppState>) {
        networkAccess.subscribe(to: StatsRefs.atBatsRef(teamId: self.teamId)) { result in
            let atBatsResult = result.map { (json: JSONObject) -> [AtBat] in
                return json.parsedObjects()
            }
            
            switch atBatsResult {
            case let .success(atBats):
                core.fire(event: Updated<[AtBat]>(atBats))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
