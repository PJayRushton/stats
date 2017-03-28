//
//  Game.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

class Game: CloudKitSyncable {

    let date: Date
    let inning: Int
    let isCompleted: Bool
    let isHome: Bool
    let isRegularSeason: Bool
    let opponent: String
    let opponentScore: Int
    let score: Int
    let seasonRef: CKReference
    let teamRef: CKReference

    var cloudKitRecordId: CKRecordID?
    
    init(date: Date, inning: Int, isCompleted: Bool, isHome: Bool, isRegularSeason: Bool, opponent: String, opponentScore: Int, score: Int, seasonRef: CKReference, teamRef: CKReference) {
        self.date = date
        self.inning = inning
        self.isCompleted = isCompleted
        self.isHome = isHome
        self.isRegularSeason = isRegularSeason
        self.opponent = opponent
        self.opponentScore = opponentScore
        self.score = score
        self.seasonRef = seasonRef
        self.teamRef = teamRef
    }
    
    required convenience init(record: CKRecord) throws {
        guard let date = record.value(forKey: dateKey) as? Date else { throw CloudKitError.keyNotFound(key: dateKey) }
        guard let inning = record.value(forKey: inningKey) as? Int else { throw CloudKitError.keyNotFound(key: inningKey) }
        guard let isCompletedInt = record.value(forKey: isCompletedKey) as? Int else { throw CloudKitError.keyNotFound(key: isCompletedKey) }
        let isCompleted = NSNumber(integerLiteral: isCompletedInt).boolValue
        guard let isHomeInt = record.value(forKey: isHomeKey) as? Int else { throw CloudKitError.keyNotFound(key: isHomeKey) }
        let isHome = NSNumber(integerLiteral: isHomeInt).boolValue
        guard let isRegularSeasonInt = record.value(forKey: isRegularSeason) as? Int else { throw CloudKitError.keyNotFound(key: isRegularSeason) }
        let isRegularSeason = NSNumber(integerLiteral: isRegularSeasonInt).boolValue
        guard let opponent = record.value(forKey: opponentKey) as? String else { throw CloudKitError.keyNotFound(key: opponentKey) }
        guard let opponentScore = record.value(forKey: opponentScoreKey) as? Int else { throw CloudKitError.keyNotFound(key: opponentScoreKey) }
        guard let score = record.value(forKey: scoreKey) as? Int else { throw CloudKitError.keyNotFound(key: scoreKey) }
        guard let season = record.value(forKey: seasonRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: seasonRefKey) }
        guard let teamRef = record.value(forKey: teamRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: teamRefKey) }
        
        self.init(date: date, inning: inning, isCompleted: isCompleted, isHome: isHome, isRegularSeason: isRegularSeason, opponent: opponent, opponentScore: opponentScore, score: score, seasonRef: season, teamRef: teamRef)
        self.cloudKitRecordId = record.recordID
    }

}

extension CKRecord {
    
    convenience init(_ game: Game) {
        let recordId = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: game.recordType, recordID: recordId)
        self.setObject(game.date as CKRecordValue, forKey: dateKey)
        self.setObject(NSNumber(integerLiteral: game.inning), forKey: inningKey)
        let isCompletedNumber = NSNumber(booleanLiteral: game.isCompleted)
        self.setObject(isCompletedNumber, forKey: isCompletedKey)
        let isHomeNumber = NSNumber(booleanLiteral: game.isHome)
        self.setObject(isHomeNumber, forKey: isHomeKey)
        let isRegularSeasonNumber = NSNumber(booleanLiteral: game.isRegularSeason)
        self.setObject(isRegularSeasonNumber, forKey: isRegularSeasonKey)
        self.setObject(game.opponent as NSString, forKey: opponentKey)
        self.setObject(game.opponentScore as NSNumber, forKey: opponentScoreKey)
        self.setObject(game.score as NSNumber, forKey: scoreKey)
        self.setObject(game.seasonRef, forKey: seasonRefKey)
        self.setObject(game.teamRef, forKey: teamRefKey)
    }
    
}
