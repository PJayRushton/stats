//
//  AtBat.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase
import Marshal

enum AtBatCode: String {
    case out
    case k
    case single
    case double
    case triple
    case hr
}

struct AtBat: Identifiable, Unmarshaling {
    
    var id: String
    var gameId: String
    var order: Int
    var playerId: String
    var rbis: Int
    var resultCode: AtBatCode
    var seasonId: String
    var teamId: String
    
    init(id: String = "", gameId: String, order: Int = 0, playerId: String, rbis: Int = 0, resultCode: AtBatCode, seasonId: String, teamId: String) {
        self.id = id
        self.gameId = gameId
        self.order = order
        self.playerId = playerId
        self.rbis = rbis
        self.resultCode = resultCode
        self.seasonId = seasonId
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gameId = try object.value(for: gameIdKey)
        order = try object.value(for: orderKey)
        playerId = try object.value(for: playerIdKey)
        rbis = try object.value(for: rbisKey)
        resultCode = try object.value(for: resultCodeKey)
        seasonId = try object.value(for: seasonIdKey)
        teamId = try object.value(for: teamIdKey)
    }
    
}

extension AtBat: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[gameIdKey] = gameId
        json[playerIdKey] = playerId
        json[resultCodeKey] = resultCode.rawValue
        json[seasonIdKey] = seasonId
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension AtBat {
    
    var ref: FIRDatabaseReference {
        return StatsRefs.atBatsRef(teamId: teamId).child(id)
    }
    
}
