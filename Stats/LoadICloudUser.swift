//
//  LoadICloudUser.swift
//  St@s
//
//  Created by Parker Rushton on 10/18/16.
//  Copyright © 2016 PJR. All rights reserved.
//

import Foundation
import CloudKit

struct LoadICloudUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        let container = CKContainer.default()
        container.fetchUserRecordID { recordID, error in
            if let recordID = recordID, error == nil {
                let id = recordID.recordName
                core.fire(event: ICloudUserLoaded(id: id))
                core.fire(command: GetCurrentUser(iCloudId: id))
            } else {
                core.fire(event: ICloudUserLoaded(id: nil))
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
