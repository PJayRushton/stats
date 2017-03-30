//
//  Season.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import CloudKit

class Season: CloudKitSyncable {
    
    let isCompleted: Bool
    let name: String
    let teamRef: CKReference
    
    var cloudKitRecordId: CKRecordID?
    
    init(isCompleted: Bool, name: String, teamRef: CKReference) {
        self.isCompleted = isCompleted
        self.name = name
        self.teamRef = teamRef
    }
    
    required convenience init(record: CKRecord) throws {
        guard let isCompletedInt = record.value(forKey: isCompletedKey) as? Int else { throw CloudKitError.keyNotFound(key: isCompletedKey) }
        let isCompleted = NSNumber(value: isCompletedInt).boolValue
        guard let name = record.value(forKey: nameKey) as? String else { throw CloudKitError.keyNotFound(key: nameKey) }
        guard let team = record.value(forKey: teamRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: teamRefKey) }
        
        self.init(isCompleted: isCompleted, name: name, teamRef: team)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(season: Season) {
        let recordId = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Season.recordName, recordID: recordId)
        let isCompletedNumber = NSNumber(booleanLiteral: season.isCompleted)
        self.setObject(isCompletedNumber, forKey: isCompletedKey)
        self.setObject(season.name as NSString, forKey: nameKey)
        self.setObject(season.teamRef, forKey: teamRefKey)
    }
    
}
