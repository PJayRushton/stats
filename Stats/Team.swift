//
//  Team.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import CloudKit

enum TeamType: Int {
    case baseball
    case fastPitch
    case slowPitch
}


class Team: CloudKitSyncable {
    
    let image: CKAsset?
    let name: String
    let type: TeamType
    let currentSeasonRef: CKReference

    var cloudKitRecordId: CKRecordID?
    
    
    // Accessors
    var imageURL: URL? {
        return image?.fileURL
    }
    
    init(image: CKAsset?, name: String, type: TeamType, currentSeasonRef: CKReference) {
        self.image = image
        self.name = name
        self.type = type
        self.currentSeasonRef = currentSeasonRef
    }
    
    required convenience init(record: CKRecord) throws {
        guard let name = record.object(forKey: nameKey) as? String else { throw CloudKitError.keyNotFound(key: nameKey) }
        guard let typeInt = record.object(forKey: typeKey) as? Int else { throw CloudKitError.keyNotFound(key: typeKey) }
        guard let type = TeamType(rawValue: typeInt) else { throw CloudKitError.parsingError(key: typeKey) }
        guard let currentSeasonRef = record.object(forKey: currentSeasonRefKey) as? CKReference else { throw CloudKitError.keyNotFound(key: currentSeasonRefKey) }
        let image = record.object(forKey: imageKey) as? CKAsset
        self.init(image: image, name: name, type: type, currentSeasonRef: currentSeasonRef)
        cloudKitRecordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(team: Team) {
        let recordId = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: team.recordType, recordID: recordId)
        self.setObject(team.image, forKey: imageKey)
        self.setObject(team.name as NSString, forKey: nameKey)
        self.setObject(NSNumber(value: team.type.rawValue), forKey: typeKey)
        self.setObject(team.currentSeasonRef, forKey: currentSeasonRefKey)
    }
    
}

/*
    let seasons: [CKReference]
    let players: [CKReference]
    let ownerIds: [CKReference]
    let managerIds: [CKReference]
    let fanIds: [CKReference]
*/
