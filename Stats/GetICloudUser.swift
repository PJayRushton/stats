//
//  GetICloudUser.swift
//  Wasatch Transportation
//
//  Created by Parker Rushton on 10/18/16.
//  Copyright © 2016 PJR. All rights reserved.
//

import Foundation
import CloudKit

struct ICloudUserIdentified: Event {
    var iCloudId: String?
}


struct GetICloudUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        let container = CKContainer.default()
        container.fetchUserRecordID { recordID, error in
            if let recordID = recordID, error == nil {
                core.fire(event: ICloudUserIdentified(iCloudId: recordID.recordName))
                core.fire(command: GetCurrentUser(iCloudId: recordID.recordName))
                currentUserCachedICloudId = recordID.recordName
            } else {
                core.fire(event: ErrorEvent(error: error, message: nil))
                core.fire(event: ICloudUserIdentified(iCloudId: nil))
            }
        }
    }
    
}

var currentUserCachedICloudId: String? {
    get {
        return UserDefaults.standard.string(forKey: #function)
    }
    set {
        UserDefaults.standard.set(newValue, forKey: #function)
    }
}
