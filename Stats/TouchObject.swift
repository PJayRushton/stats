//
//  TouchObject.swift
//  Stats
//
//  Created by Parker Rushton on 4/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct TouchObject<T: Identifiable>: Command {
    
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkAccess.teamsRef.child(object.id)
        let parameters: JSONObject = ["touchDate": Date().iso8601String]
        networkAccess.updateObject(at: ref, parameters: parameters, completion: nil)
    }
    
}
