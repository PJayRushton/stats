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

struct AtBat: Marshaling, Unmarshaling {
    
    let gameId: String
    let playerId: String
    let rbis: Int
    let resultCode: AtBatCode
    let seasonId: String
    
    init(gameId: String, playerId: CKIderence, rbis: Int = 0, resultCode: AtBatCode, seasonId: String) {
        self.gameId = gameId
        self.playerId = playerId
        self.rbis = rbis
        self.resultCode = resultCode
        self.seasonId = seasonId
    }
    
    
}
