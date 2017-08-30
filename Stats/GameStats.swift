//
//  GameStats.swift
//  Stats
//
//  Created by Parker Rushton on 8/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct GameStats {
    
    var id: String
    var gameId: String
    var isSeason = false
    var teamId: String
    var stats = [String: [Stat]]()
    
    var allStats: [Stat] {
        return stats.values.joined().flatMap { $0 }
    }
    
    init(_ game: Game) {
        self.id = UUID().uuidString
        self.gameId = game.id
        self.teamId = game.teamId
    }
    
    init(_ season: Season) {
        self.id = UUID().uuidString
        self.gameId = season.id
        self.isSeason = true
        self.teamId = season.teamId
    }
    
}


// MARK: - Unmarshaling

extension GameStats: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gameId = try object.value(for: gameIdKey)
        isSeason = try object.value(for: isSeasonKey) ?? false
        teamId = try object.value(for: teamIdKey)
        
        let statsJSON: JSONObject = try object.value(for: statsKey)
        statsJSON.keys.forEach { playerId in
            guard let statsDict: [String: Double] = try? statsJSON.value(for: playerId) else { return }
            let stats = statsDict.flatMap { Stat(playerId: playerId, type: StatType(rawValue: $0.key)!, value: $0.value) }
            self.stats[playerId] = stats
        }
    }
    
}


// MARK: - JSONMarshaling

extension GameStats: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        var object = JSONObject()
        object[idKey] = id
        object[gameIdKey] = gameId
        object[isSeasonKey] = isSeason
        object[teamIdKey] = teamId
        var statsObject = JSONObject()
        stats.forEach { playerId, playerStats in
            var object = JSONObject()
            playerStats.forEach { object[$0.type.rawValue] = $0.value }
            statsObject[playerId] = object
        }
        object[statsKey] = statsObject
        
        return object
    }
    
}
