//
//  LogAnalyticsAction.swift
//  Stats
//
//  Created by Parker Rushton on 5/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

enum AnalyticsAction: String {
    case stockPhotoUsed
    case stockPhotoLayoutChanged
    case playerCreatedFromContacts
    case playerNumberAddedFromContacts
}

struct LogAnalyticsAction: Event {
    
    var action: AnalyticsAction
    var parameters: [String: Any]?
    
    init(action: AnalyticsAction, parameters: [String: Any]? = nil) {
        self.action = action
        self.parameters = parameters
    }
    
}
