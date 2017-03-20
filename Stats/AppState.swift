//
//  AppState.swift
//  Stats
//
//  Created by Parker Rushton on 3/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum App {
    static let core = Core(state: AppState(), middlewares: [])
}


struct AppState: State {
    
    mutating func react(to event: Event) {
        switch event {
        default:
            break
        }
    }
}
