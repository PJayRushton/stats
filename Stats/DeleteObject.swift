//
//  DeleteObject.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct DeleteObject<T: Identifiable>: Command {
    
    var object: T
    
    init(_ object: T) {
        self.object = object
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.deleteObject(at: object.ref, completion: nil)
    }
    
}
