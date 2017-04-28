//
//  SetObject.swift
//  Stats
//
//  Created by Parker Rushton on 4/28/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct SetObject<T: Identifiable>: Command {
    
    var object: T
    var completion: ((Bool) -> Void)?
    
    init(_ object: T, completion: ((Bool) -> Void)? = nil) {
        self.object = object
        self.completion = completion
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.setValue(at: object.ref, parameters: object.marshaled() as! JSONObject) { result in
            switch result {
            case .success:
                core.fire(event: Updated(self.object))
                self.completion?(true)
            case let .failure(error):
                self.completion?(false)
                core.fire(event: ErrorEvent(error: error, message: "Failed to update object \(self.object)"))
            }
        }
    }
    
}
