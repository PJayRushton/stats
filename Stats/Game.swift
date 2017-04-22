//
//  Game.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase
import Marshal

struct Game: Identifiable, Unmarshaling {

    var id: String
    var date: Date
    var inning: Int
    var isCompleted: Bool
    var isHome: Bool
    var isRegularSeason: Bool
    var lineupIds: [String]
    var opponent: String
    var opponentScore: Int
    var score: Int
    var seasonId: String
    var teamId: String

    init(id: String = "", date: Date, inning: Int = 1, isCompleted: Bool = false, isHome: Bool, isRegularSeason: Bool = true, lineupIds: [String] = [], opponent: String, opponentScore: Int = 0, score: Int = 0, seasonId: String, teamId: String) {
        self.id = id
        self.date = date
        self.inning = inning
        self.isCompleted = isCompleted
        self.isHome = isHome
        self.isRegularSeason = isRegularSeason
        self.lineupIds = lineupIds
        self.opponent = opponent
        self.opponentScore = opponentScore
        self.score = score
        self.seasonId = seasonId
        self.teamId = teamId
    }
    
    var wasWon: Bool? {
        guard opponentScore != score && isCompleted else { return nil }
        return score > opponentScore
    }

    var scoreString: String {
        let firstScore = isHome ? opponentScore : score
        let secondScore = isHome ? score : opponentScore
        return "\(firstScore) - \(secondScore)"
    }
    
    var status: String {
        if isCompleted {
            guard let wasWon = wasWon else { return "🚫" }
            return wasWon ? "W" : "L"
        } else {
            let inningPrefix = isHome ? "⬇️" : "⬆️"
            return "\(inningPrefix) \(inning)"
        }
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        date = try object.value(for: dateKey)
        inning = try object.value(for: inningKey)
        isCompleted = try object.value(for: isCompletedKey)
        isHome = try object.value(for: isHomeKey)
        isRegularSeason = try object.value(for: isRegularSeasonKey)
        lineupIds = try object.value(for: lineupKey)
        opponent = try object.value(for: opponentKey)
        opponentScore = try object.value(for: opponentScoreKey)
        score = try object.value(for: scoreKey)
        seasonId = try object.value(for: seasonIdKey)
        teamId = try object.value(for: teamIdKey)
    }
    
    func isTheSame(as otherGame: Game) -> Bool {
        return id == otherGame.id &&
        date == otherGame.date &&
        isHome == otherGame.isHome &&
        isRegularSeason == otherGame.isRegularSeason &&
        opponent == otherGame.opponent &&
        lineupIds == otherGame.lineupIds
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
        json[lineupKey] = lineupIds.marshaledArray()
        json[opponentKey] = opponent
        json[opponentScoreKey] = opponentScore
        json[scoreKey] = score
        json[seasonIdKey] = seasonId
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension Game {
    
    var ref: FIRDatabaseReference {
        return StatsRefs.gamesRef(teamId: teamId).child(id)
    }
    
}
