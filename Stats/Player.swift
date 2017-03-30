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
    let teamRef: CKReference
    
    var cloudKitRecordId: CKRecordID?

    init(name: String, jerseyNumber: String?, isSub: Bool = false, phone: String? = nil, gender: Gender = .unspecified, teamRef: CKReference) {
        self.name = name
        self.jerseyNumber = jerseyNumber
        self.isSub = isSub
        self.phone = phone
        self.gender = gender
        self.teamRef = teamRef
    }

    required convenience init(record: CKRecord) throws {
        guard let name = record.object(forKey: nameKey) as? String else { throw CloudKitError.keyNotFound(key: nameKey) }
        let jerseyNumber = record.object(forKey: jerseyNumberKey) as? String
        guard let subInt = record.object(forKey: isSubKey) as? Int else { throw CloudKitError.keyNotFound(key: isSubKey) }
        let isSub = NSNumber(value: subInt).boolValue
        let phone = record.object(forKey: phoneKey) as? String
        guard let genderInt = record.object(forKey: genderKey) as? String else { throw CloudKitError.keyNotFound(key: genderKey) }
        guard let gender = Gender(rawValue: genderInt) else { throw CloudKitError.parsingError(key: genderKey) }
        guard let teamRef = record.object(forKey: teamRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: teamRefKey) }

        self.init(name: name, jerseyNumber: jerseyNumber, isSub: isSub, phone: phone, gender: gender, teamRef: teamRef)
        cloudKitRecordId = record.recordID
    }
}

extension CKRecord {
    
    convenience init(player: Player) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Player.recordName, recordID: recordID)
        self.setObject(player.name as NSString, forKey: nameKey)
        self.setObject(player.jerseyNumber as CKRecordValue?, forKey: jerseyNumberKey)
        self.setObject(NSNumber(booleanLiteral: player.isSub), forKey: isSubKey)
        self.setObject(player.phone as NSString?, forKey: phoneKey)
        self.setObject(player.gender.rawValue as NSString, forKey: genderKey)
        self.setObject(player.teamRef, forKey: teamRefKey)
    }
    
}
