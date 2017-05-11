//
//  QuotesState.swift
//  Stats
//
//  Created by Parker Rushton on 5/10/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct QuotesState: State {
    
    var quotes =  [Quote]()
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<[Quote]>:
            quotes = event.payload
        default:
            break
        }
    }
    
}
