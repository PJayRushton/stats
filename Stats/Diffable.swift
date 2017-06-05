//
//  Diffable.swift
//  Stats
//
//  Created by Parker Rushton on 6/5/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

protocol Diffable: Equatable {
    func isSame(as other: Self) -> Bool
}
