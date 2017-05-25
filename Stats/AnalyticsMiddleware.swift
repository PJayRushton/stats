//
//  AnalyticsMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 5/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase

struct AnalyticsMiddleware: Middleware {
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as LogAnalyticsAction:
            Analytics.logEvent(event.action.rawValue, parameters: event.parameters)
        case let event as Selected<User>:
            Analytics.setUserID(event.item?.id)
        default:
            break
        }
    }
    
}
