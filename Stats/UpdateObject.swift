//
//  UpdateObject.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct UpdateObject<T: Identifiable>: Command {
    
    var object: T
    var completion: ((Bool) -> Void)?
    
    init(_ object: T, completion: ((Bool) -> Void)? = nil) {
        self.object = object
        self.completion = completion
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.updateObject(at: object.ref, parameters: object.marshaled() as! JSONObject) { result in
            switch result {
            case .success:
                core.fire(event: Updated(self.object))
                
                DispatchQueue.main.async {
                    self.completion?(true)
                }
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: "Failed to update object \(self.object)"))
                
                DispatchQueue.main.async {
                    self.completion?(false)
                }
            }
        }
    }
    
}
