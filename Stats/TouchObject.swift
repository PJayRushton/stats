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
        let parameters: JSONObject = ["touchDate": Date().iso8601String]
        networkAccess.updateObject(at: object.ref, parameters: parameters) { result in
            switch result {
            case .success:
                core.fire(event: Updated(self.object))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: "Failed to update object \(self.object)"))
            }
        }
    }
    
}
