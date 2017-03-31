//
//  AtBat.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

enum AtBatCode: String {
    case out
    case k
    case single
    case double
    case triple
    case hr
}

struct AtBat: Unmarshaling {
    
    var id: String
    var gameId: String
    var playerId: String
    var rbis: Int
    var resultCode: AtBatCode
    var seasonId: String
    
    init(id: String = "", gameId: String, playerId: String, rbis: Int = 0, resultCode: AtBatCode, seasonId: String) {
        self.id = id
        self.gameId = gameId
        self.playerId = playerId
        self.rbis = rbis
        self.resultCode = resultCode
        self.seasonId = seasonId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gameId = try object.value(for: gameIdKey)
        playerId = try object.value(for: playerIdKey)
        rbis = try object.value(for: rbisKey)
        resultCode = try object.value(for: resultCodeKey)
        seasonId = try object.value(for: seasonIdKey)
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
        return json
    }
    
}
