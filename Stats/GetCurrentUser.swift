//
//  GetCurrentUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/22/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Marshal

struct GetCurrentUser: Command {
    
    var iCloudId: String
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.usersRef.queryOrdered(byChild: iCloudKey).queryEqual(toValue: iCloudId).observeSingleEvent(of: .value, with: { snapshot in
            if let snapValueJSON = snapshot.value as? JSONObject,
                let idKey = Array(snapValueJSON.keys).first,
                let userDict: JSONObject = try? snapValueJSON.value(for: idKey),
                snapshot.exists() {
                    let user = try? User(object: userDict)
                    core.fire(event: Selected<User>(user))
            } else {
                core.fire(command: SaveNewUser())
            }
        })
    }
    
}
