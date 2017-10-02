//
//  Identifiable.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase
import Marshal

protocol Identifiable: JSONMarshaling, Unmarshaling, Hashable {
    var id: String { get set }
    var ref: DatabaseReference { get }
}


extension Identifiable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
}

func ==<T: Identifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
