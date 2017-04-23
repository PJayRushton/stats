//
//  Gender.swift
//  Stats
//
//  Created by Parker Rushton on 4/23/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum Gender: Int {
    case unspecified
    case male
    case female
    
    var stringValue: String {
        switch self {
        case .unspecified:
            return "Unspecified"
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
    var color: UIColor {
        switch self {
        case .unspecified:
            return .white
        case .male:
            return UIColor.flatSkyBlue.withAlphaComponent(0.1)
        case .female:
            return UIColor.flatLimeDark.withAlphaComponent(0.1)
        }
    }
    
    static let allValues = [Gender.unspecified, .male, .female]
}
