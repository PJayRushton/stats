//
//  AtBat.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

enum AtBatCode: String {
    case out
    case k
    case single
    case double
    case triple
    case hr
}

class AtBat: CloudKitSyncable {
    
    let game: CKReference
    let player: CKReference
    let rbis: Int
    let resultCode: AtBatCode
    let season: CKReference
    
    var cloudKitRecordId: CKRecordID?
    
    init(game: CKReference, player: CKReference, rbis: Int = 0, resultCode: AtBatCode, season: CKReference) {
        self.game = game
        self.player = player
        self.rbis = rbis
        self.resultCode = resultCode
        self.season = season
    }
    
    required convenience init(record: CKRecord) throws {
        guard let game = record.value(forKey: "game") as? CKReference else { throw CloudKitError.keyNotFound(key: "game") }
        guard let player = record.value(forKey: "player") as? CKReference else { throw CloudKitError.keyNotFound(key: "player") }
        guard let rbis = record.value(forKey: "rbis") as? Int else { throw CloudKitError.keyNotFound(key: "rbis") }
        guard let resultCodeString = record.value(forKey: "resultCode") as? String else { throw CloudKitError.keyNotFound(key: "resultCode") }
        guard let resultCode = AtBatCode(rawValue: resultCodeString) else { throw CloudKitError.parsingError(key: "resultCode") }
        guard let season = record.value(forKey: "season") as? CKReference else { throw CloudKitError.keyNotFound(key: "season") }
        
        self.init(game: game, player: player, rbis: rbis, resultCode: resultCode, season: season)
        cloudKitRecordId = record.recordID
    }
}
