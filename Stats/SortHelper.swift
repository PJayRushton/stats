//
//  ContactsHelper.swift
//  Stats
//
//  Created by Parker Rushton on 9/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

protocol StatSortable {
    var type: StatType { get set }
}


// MARK: - Sorting functions

extension Collection where Self.Iterator.Element: StatSortable {
    
    func customSorted() -> [Self.Iterator.Element] {
        return self.sorted(by: { return StatType.allValues.index(of: $0.type)! < StatType.allValues.index(of: $1.type)! })
    }
    
}
