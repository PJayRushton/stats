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
        subscribeToStats(core: core)
    }
    
    private func subscribeToTeam(core: Core<AppState>) {
        let ref = StatsRefs.teamsRef.child(teamId)
        
        networkAccess.subscribe(to: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                core.fire(event: Updated<Team>(team))
                
                if let currentTeamId = core.state.teamState.currentTeamId, self.teamId == currentTeamId, let seasonId = team.currentSeasonId {
                    core.fire(command: SubscribeToAtBats(of: team.id, newSeasonId: seasonId))
                }

            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToSeasons(core: Core<AppState>) {
        let ref = StatsRefs.seasonsRef(teamId: self.teamId)
        networkAccess.fullySubscribe(to: ref) { result, eventType in
            let seasonResult = result.map(Season.init)
            
            switch seasonResult {
            case let .success(season):
                switch eventType {
                case .childAdded:
                    core.fire(event: TeamObjectAdded<Season>(object: season, teamId: self.teamId))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<Season>(object: season, teamId: self.teamId))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<Season>(object: season, teamId: self.teamId))
                default:
                    break
                }
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }

    private func subscribeToPlayers(core: Core<AppState>) {
        let ref = StatsRefs.playersRef(teamId: self.teamId)
        networkAccess.fullySubscribe(to: ref) { result, eventType in
            let playerResult = result.map(Player.init)

            switch playerResult {
            case let .success(player):
                switch eventType {
                case .childAdded:
                    core.fire(event: TeamObjectAdded<Player>(object: player, teamId: self.teamId))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<Player>(object: player, teamId: self.teamId))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<Player>(object: player, teamId: self.teamId))
                default:
                    break
                }
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToGames(core: Core<AppState>) {
        let ref = StatsRefs.gamesRef(teamId: self.teamId)
        networkAccess.fullySubscribe(to: ref) { result, eventType in
            let gameResult = result.map(Game.init)
            
            switch gameResult {
            case let .success(game):
                switch eventType {
                case .childAdded:
                    core.fire(event: TeamObjectAdded<Game>(object: game, teamId: self.teamId))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<Game>(object: game, teamId: self.teamId))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<Game>(object: game, teamId: self.teamId))
                default:
                    break
                }
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func subscribeToStats(core: Core<AppState>) {
        let ref = StatsRefs.gameStatsRef(teamId: self.teamId)
        networkAccess.fullySubscribe(to: ref) { result, eventType in
            let gameStatResult = result.map(GameStats.init)
            switch gameStatResult {
            case let .success(gameStats):
                switch eventType {
                case .childAdded:
                    core.fire(event: TeamObjectAdded<GameStats>(object: gameStats, teamId: self.teamId))
                case .childChanged:
                    core.fire(event: TeamObjectChanged<GameStats>(object: gameStats, teamId: self.teamId))
                case .childRemoved:
                    core.fire(event: TeamObjectRemoved<GameStats>(object: gameStats, teamId: self.teamId))
                default:
                    break
                }
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
