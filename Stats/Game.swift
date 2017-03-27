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
    let season: CKReference
    let team: CKReference

    var cloudKitRecordId: CKRecordID?
    
    init(date: Date, inning: Int, isCompleted: Bool, isHome: Bool, isRegularSeason: Bool, opponent: String, opponentScore: Int, score: Int, season: CKReference, team: CKReference) {
        self.date = date
        self.inning = inning
        self.isCompleted = isCompleted
        self.isHome = isHome
        self.isRegularSeason = isRegularSeason
        self.opponent = opponent
        self.opponentScore = opponentScore
        self.score = score
        self.season = season
        self.team = team
    }
    
    required convenience init(record: CKRecord) throws {
        guard let date = record.value(forKey: "date") as? Date else { throw CloudKitError.keyNotFound(key: "date") }
        guard let inning = record.value(forKey: "inning") as? Int else { throw CloudKitError.keyNotFound(key: "inning") }
        guard let isCompletedInt = record.value(forKey: "isCompleted") as? Int else { throw CloudKitError.keyNotFound(key: "isCompleted") }
        let isCompleted = NSNumber(integerLiteral: isCompletedInt).boolValue
        guard let isHomeInt = record.value(forKey: "isHome") as? Int else { throw CloudKitError.keyNotFound(key: "isHome") }
        let isHome = NSNumber(integerLiteral: isHomeInt).boolValue
        guard let isRegularSeasonInt = record.value(forKey: "isRegularSeason") as? Int else { throw CloudKitError.keyNotFound(key: "isRegularSeason") }
        let isRegularSeason = NSNumber(integerLiteral: isRegularSeasonInt).boolValue
        guard let opponent = record.value(forKey: "opponent") as? String else { throw CloudKitError.keyNotFound(key: "opponent") }
        guard let opponentScore = record.value(forKey: "opponentScore") as? Int else { throw CloudKitError.keyNotFound(key: "opponentScore") }
        guard let score = record.value(forKey: "score") as? Int else { throw CloudKitError.keyNotFound(key: "score") }
        guard let season = record.value(forKey: "season") as? CKReference else { throw CloudKitError.keyNotFound(key: "season") }
        guard let team = record.value(forKey: "team") as? CKReference else { throw CloudKitError.keyNotFound(key: "team") }
        
        self.init(date: date, inning: inning, isCompleted: isCompleted, isHome: isHome, isRegularSeason: isRegularSeason, opponent: opponent, opponentScore: opponentScore, score: score, season: season, team: team)
        self.cloudKitRecordId = record.recordID
    }

}
