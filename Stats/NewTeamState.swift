//
//  NewTeamState.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

struct Loading<T>: Event {
    var object: T?
    
    init(_ object: T? = nil) {
        self.object = object
    }
    
}

struct NewTeamState: State {
    
    var imageURL: URL?
    var isLoading = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<URL>:
            imageURL = event.item
            isLoading = false
        case _ as Loading<URL>:
            isLoading = true
        default:
            break
        }
    }
    
}
