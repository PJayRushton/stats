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
        let ref = networkController.usersRef.child(newUser.id)
        networkController.setValue(at: ref, parameters: newUser.marshaled(), completion: nil)
    }
    
    private func newUser(state: AppState) -> User? {
        guard let iCloudId = state.userState.iCloudId, let username = state.newUserState.username else { return nil }
        return User(id: iCloudId, username: username)
    }
    
}
