//
//  LoadICloudUser.swift
//  Wasatch Transportation
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
                
            } else {
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
