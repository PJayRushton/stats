//
//  Identifiable.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

protocol Identifiable: Equatable, Marshaling, Unmarshaling, Hashable {
    var id: String { get set }
}


extension Identifiable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
}

func ==<T: Identifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
