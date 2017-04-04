//
//  SaveNewUser.swift
//  Wasatch Transportation
//
//  Created by Parker Rushton on 10/19/16.
//  Copyright © 2016 PJR. All rights reserved.
//

import Foundation
import Marshal

struct SaveNewUser: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let newUser = newUser(state: state) else { return }
        networkAccess.setValue(at: newUser.ref, parameters: newUser.marshaled()) { result in
            if case .success = result {
                core.fire(command: SubscribeToCurrentUser(id: newUser.id))
            }
        }
    }
    
    private func newUser(state: AppState) -> User? {
        guard let iCloudId = state.userState.iCloudId, let username = state.newUserState.username else { return nil }
        let email = state.newUserState.email
        return User(id: iCloudId, username: username, email: email)
    }
    
}
