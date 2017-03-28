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
    
    let gameRef: CKReference
    let playerRef: CKReference
    let rbis: Int
    let resultCode: AtBatCode
    let seasonRef: CKReference
    
    var cloudKitRecordId: CKRecordID?
    
    init(gameRef: CKReference, playerRef: CKReference, rbis: Int = 0, resultCode: AtBatCode, seasonRef: CKReference) {
        self.gameRef = gameRef
        self.playerRef = playerRef
        self.rbis = rbis
        self.resultCode = resultCode
        self.seasonRef = seasonRef
    }
    
    required convenience init(record: CKRecord) throws {
        guard let gameRef = record.value(forKey: gameRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: gameRefKey) }
        guard let playerRef = record.value(forKey: playerRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: playerRefKey) }
        guard let rbis = record.value(forKey: rbisKey) as? Int else { throw CloudKitError.keyNotFound(key: rbisKey) }
        guard let resultCodeString = record.value(forKey: resultCodeKey) as? String else { throw CloudKitError.keyNotFound(key: resultCodeKey) }
        guard let resultCode = AtBatCode(rawValue: resultCodeString) else { throw CloudKitError.parsingError(key: resultCodeKey) }
        guard let seasonRef = record.value(forKey: seasonRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: seasonRefKey) }
        
        self.init(gameRef: gameRef, playerRef: playerRef, rbis: rbis, resultCode: resultCode, seasonRef: seasonRef)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(atBat: AtBat) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: atBat.recordType, recordID: recordID)
        self.setObject(atBat.gameRef, forKey: gameRefKey)
        self.setObject(atBat.playerRef, forKey: playerRefKey)
        self.setObject(atBat.rbis as NSNumber, forKey: rbisKey)
        self.setObject(atBat.resultCode.rawValue as NSString, forKey: resultCodeKey)
        self.setObject(atBat.seasonRef, forKey: seasonRefKey)
    }
    
}
