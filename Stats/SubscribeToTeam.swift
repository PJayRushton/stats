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
        let ref = StatsRefs.teamsRef.child(teamId)
        
        networkAccess.subscribe(to: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                core.fire(event: Updated<Team>(team))
                self.subscribeToPlayers(core: core)
                self.subscribeToGames(core: core)
                self.subscribeToAtBats(core: core)
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
                guard self.teamId == core.state.teamState.currentTeam?.id else { return }
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
                guard self.teamId == core.state.teamState.currentTeam?.id else { return }
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
                guard self.teamId == core.state.teamState.currentTeam?.id else { return }
                core.fire(event: Updated<[AtBat]>(atBats))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
