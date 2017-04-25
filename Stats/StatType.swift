//
//  StatType.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum StatType: String {
    case atBats
    case battingAverage
    case doubles
    case gamesPlayed
    case grandSlams
    case hits
    case homeRuns
    case onBasePercentage
    case rbis
    case reachOnError
    case singles
    case strikeOuts
    case triples
    case walks
    
    static let allValues = [StatType.battingAverage, .onBasePercentage, .hits, .atBats, .singles, .doubles, .triples, .homeRuns, .grandSlams, .rbis, .walks, .strikeOuts, .reachOnError, .gamesPlayed]
    
    var abbreviation: String {
        switch self {
        case .atBats:
            return "AB"
        case .battingAverage:
            return "BA"
        case .doubles:
            return "2B"
        case .gamesPlayed:
            return "G"
        case .grandSlams:
            return "GS"
        case .hits:
            return "H"
        case .homeRuns:
            return "HR"
        case .onBasePercentage:
            return "OBP"
        case .rbis:
            return "RBIs"
        case .reachOnError:
            return "ROE"
        case .singles:
            return "1B"
        case .strikeOuts:
            return "K"
        case .triples:
            return "3B"
        case .walks:
            return "W"
        }
    }
    
}
