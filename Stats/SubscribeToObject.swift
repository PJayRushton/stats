//
//  SubscribeToObject.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SubscribeToObject<T: Identifiable>: Command {
    
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.subscribe(to: object.ref) { result in
            let objectResult = result.map(T.init)
            switch objectResult {
            case let .success(parsedObject):
                core.fire(event: Updated(parsedObject))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
