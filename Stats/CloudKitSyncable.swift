//
//  CloudKitSyncable.swift
//  Timeline
//
//  Created by Andrew Madsen on 8/1/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable: Equatable, Hashable {
	
	init(record: CKRecord) throws

	var cloudKitRecordId: CKRecordID? { get set }
}

extension CloudKitSyncable {
    
	var isSynced: Bool {
		return cloudKitRecordId != nil
	}
	
    var recordType: String {
        return String(describing: self)
    }
    
	var cloudKitReference: CKReference? {
		guard let recordId = cloudKitRecordId else { return nil }
		return CKReference(recordID: recordId, action: .none)
	}
    
}

extension CloudKitSyncable {
    
    var hashValue: Int {
        return cloudKitRecordId!.hashValue /*?? (gameRef.recordID.hashValue + playerRef.recordID.hashValue + resultCode.hashValue + rbis) */
    }

}

func ==<T: CloudKitSyncable>(lhs: T, rhs: T) -> Bool {
    return lhs.cloudKitRecordId == rhs.cloudKitRecordId
}


enum CloudKitError: Error {
    case keyNotFound(key: String)
    case parsingError(key: String)
}
