//
//  Game.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct Game: Unmarshaling {

    var id: String
    var date: Date
    var inning: Int
    var isCompleted: Bool
    var isHome: Bool
    var isRegularSeason: Bool
    var opponent: String
    var opponentScore: Int
    var score: Int
    var seasonId: String
    var teamId: String

    init(id: String = "", date: Date, inning: Int, isCompleted: Bool, isHome: Bool, isRegularSeason: Bool, opponent: String, opponentScore: Int, score: Int, seasonId: String, teamId: String) {
        self.id = id
        self.date = date
        self.inning = inning
        self.isCompleted = isCompleted
        self.isHome = isHome
        self.isRegularSeason = isRegularSeason
        self.opponent = opponent
        self.opponentScore = opponentScore
        self.score = score
        self.seasonId = seasonId
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try json.value(for: idKey)
        date = try json.value(for: dateKey)
        inning = try json.value(for: inningKey)
        isCompleted = NSNumber(value: isCompletedInt).boolValue
        isRegularSeasonInt = try json.value(for: isRegularSeasonKey)
        opponent = try json.value(for: opponentKey)
        opponentScore = try json.value(for: opponentScoreKey)
        score = try json.value(for: scoreKey)
        season = try json.value(for: seasonIdKey)
        teamId = try json.value(for: teamIdKey)
    }
    
}

extension Game: Marshaling {
    
    func marshaled() ->JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[dateKey] = date.iso8601String
        json[inningKey] = inning
        json[isCompletedKey] = isCompleted
        json[isHomeKey] = isHome
        json[isRegularSeasonKey] = isRegularSeason
        json[opponentKey] = opponent
        json[opponentScoreKey] = opponentScore
        json[scoreKey] = score
        json[seasonIdKey] = seasonId
        json[teamIdKey] = teamId
        
        return json
    }
    
}
