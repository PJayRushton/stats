//
//  NewTeamState.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct NewTeamState: State {
    
    var season: Season?
    var imageURL: URL?
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<Season>:
            season = event.payload
        case let event as Selected<URL>:
            imageURL = event.item
        default:
            break
        }
    }
    
}
