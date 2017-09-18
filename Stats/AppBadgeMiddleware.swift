//
//  AppBadgeMiddleware.swift
//  Stats
//
//  Created by Parker Rushton on 9/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct AppBadgeUpdated: Event {
    var newValue: Int
}

struct AppBadgeMiddleware: Middleware {
    
    func process(event: Event, state: AppState) {
        switch event {
        case let event as AppBadgeUpdated:
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = event.newValue
            }
        case _ as Updated<Game>:
            App.core.fire(command: UpdateBadgeCount())
        case _ as Selected<User>:
            App.core.fire(command: UpdateBadgeCount())
        case _ as TeamObjectAdded<GameStats>:
            App.core.fire(command: UpdateBadgeCount())
        case _ as TeamObjectChanged<GameStats>:
            App.core.fire(command: UpdateBadgeCount())
            
        default:
            break
        }
    }
    
}
