//
//  SaveNewUser.swift
//  Wasatch Transportation
//
//  Created by Parker Rushton on 10/19/16.
//  Copyright © 2016 PJR. All rights reserved.
//

import Foundation
import Firebase
import Marshal

struct SaveNewUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkAccess.usersRef.childByAutoId()
        let user = newUser(id: ref.key)
        
        networkAccess.setValue(at: ref, parameters: user.marshaled()) { result in
            switch result {
            case .success:
                core.fire(event: Selected<User>(user))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    private func newUser(id: String) -> User {
        let cloudKitId = App.core.state.currentICloudId
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        return User(id: id, cloudKitId: cloudKitId, deviceId: deviceId)
    }
    
}
