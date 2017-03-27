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
    let currentSeason: CKReference

    var cloudKitRecordId: CKRecordID?
    
    init(image: CKAsset?, name: String, type: TeamType, currentSeason: CKReference) {
        self.image = image
        self.name = name
        self.type = type
        self.currentSeason = currentSeason
    }
    
    required convenience init(record: CKRecord) throws {
        guard let name = record.object(forKey: "name") as? String else { throw CloudKitError.keyNotFound(key: "name") }
        guard let typeInt = record.object(forKey: "type") as? Int else { throw CloudKitError.keyNotFound(key: "type") }
        guard let type = TeamType(rawValue: typeInt) else { throw CloudKitError.parsingError(key: "type") }
        guard let currentSeason = record.object(forKey: "currentSeason") as? CKReference else { throw CloudKitError.keyNotFound(key: "currentSeason") }
        let image = record.object(forKey: "image") as? CKAsset
        self.init(image: image, name: name, type: type, currentSeason: currentSeason)
        cloudKitRecordId = record.recordID
    }
    
/*
    let seasons: [CKReference]
    let players: [CKReference]
    let ownerIds: [CKReference]
    let managerIds: [CKReference]
    let fanIds: [CKReference]
*/
}
