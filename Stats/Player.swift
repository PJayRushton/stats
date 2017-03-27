//
//  Player.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

enum Gender: String {
    case unspecified
    case male
    case female
}

class Player: CloudKitSyncable {
    
    let name: String
    let jerseyNumber: String?
    let isSub: Bool
    let phone: String?
    let gender: Gender
    let team: CKReference
    var cloudKitRecordId: CKRecordID?
    
    init(name: String, jerseyNumber: String?, isSub: Bool = false, phone: String? = nil, gender: Gender = .unspecified, team: CKReference) {
        self.name = name
        self.jerseyNumber = jerseyNumber
        self.isSub = isSub
        self.phone = phone
        self.gender = gender
        self.team = team
    }
    
    required convenience init(record: CKRecord) throws {
        guard let name = record.object(forKey: "name") as? String else { throw CloudKitError.keyNotFound(key: "name") }
        let jerseyNumber = record.object(forKey: "jerseyNumber") as? String
        guard let subInt = record.object(forKey: "isSub") as? Int else { throw CloudKitError.keyNotFound(key: "isSub") }
        let isSub = NSNumber(integerLiteral: subInt).boolValue
        let phone = record.object(forKey: "phone") as? String
        guard let genderInt = record.object(forKey: "gender") as? String else { throw CloudKitError.keyNotFound(key: "gender") }
        guard let gender = Gender(rawValue: genderInt) else { throw CloudKitError.parsingError(key: "gender") }
        guard let team = record.object(forKey: "team") as? CKReference else { throw CloudKitError.keyNotFound(key: "team") }
        
        self.init(name: name, jerseyNumber: jerseyNumber, isSub: isSub, phone: phone, gender: gender, team: team)
        cloudKitRecordId = record.recordID
    }
    
}
