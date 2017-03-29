//
//  SaveNewUser.swift
//  Wasatch Transportation
//
//  Created by Parker Rushton on 10/19/16.
//  Copyright © 2016 PJR. All rights reserved.
//

import Foundation
import CloudKit
import Marshal

struct SaveNewUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let newUser = newUser(state: state.newUserState) else { return }
        
        cloudManager.saveRecord(CKRecord(user: newUser)) { record, error in
            if error == nil, let _ = record {
                core.fire(event: Selected<User>(newUser))
            } else {
                core.fire(event: ErrorEvent(error: error, message: "Unable to save new user"))
            }
        }
    }
    
    private func newUser(state: NewUserState) -> User? {
        guard let cloudKitId = state.userRecordID, let username = state.username else { return nil }
        let avatarAsset = try? CKAsset(image: state.avatar)
        return User(cloudKitId: cloudKitId, username: username, avatar: avatarAsset, email: state.email)
    }
    
}
