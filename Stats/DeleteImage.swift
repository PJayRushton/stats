//
//  DeleteImage.swift
//  Stats
//
//  Created by Parker Rushton on 4/5/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct DeleteImage<T: Identifiable>: Command {
    
    var object: T
    
    func execute(state: AppState, core: Core<AppState>) {
        var ref: FIRStorageReference = FIRStorageReference()
        if object is Team {
            ref = StatsRefs.teamImageStorageRef(teamId: object.id)
        } else if object is User {
            ref = StatsRefs.userAvatarStorageRef(userId: object.id)
        }
        
        ref.delete(completion: nil)
    }
    
}
