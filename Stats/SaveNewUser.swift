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
    
    var completion: (Bool) -> Void
    
    init(completion: @escaping ((Bool) -> Void)) {
        self.completion = completion
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let newUser = newUser(state: state) else {
            completion(false)
            return
        }
        networkAccess.setValue(at: newUser.ref, parameters: newUser.jsonObject()) { result in
            switch result {
            case .success:
                self.completion(true)
                core.fire(command: SubscribeToCurrentUser(id: newUser.id))
            case .failure:
                self.completion(false)
            }
        }
    }
    
    private func newUser(state: AppState) -> User? {
        guard let iCloudId = state.userState.iCloudId else { return nil }
        let email = state.newUserState.email
        return User(id: iCloudId, email: email)
    }
    
}
