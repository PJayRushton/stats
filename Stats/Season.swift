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
    let team: CKReference
    
    var cloudKitRecordId: CKRecordID?
    
    init(isCompleted: Bool, name: String, team: CKReference) {
        self.isCompleted = isCompleted
        self.name = name
        self.team = team
    }
    
    required convenience init(record: CKRecord) throws {
        guard let isCompletedInt = record.value(forKey: "isCompleted") as? Int else { throw CloudKitError.keyNotFound(key: "isCompleted") }
        let isCompleted = NSNumber(integerLiteral: isCompletedInt).boolValue
        guard let name = record.value(forKey: "name") as? String else { throw CloudKitError.keyNotFound(key: "name") }
        guard let team = record.value(forKey: "team") as? CKReference else { throw CloudKitError.keyNotFound(key: "team") }
        
        self.init(isCompleted: isCompleted, name: name, team: team)
        cloudKitRecordId = record.recordID
    }
    
}
