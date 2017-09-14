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
    case hitByPitches
    case homeRuns
    case itpHRs
    case onBasePercentage
    case plateAppearances
    case rbis
    case reachOnError
    case singles
    case slugging
    case strikeOuts
    case triples
    case walks
    
    static let allValues = [StatType.battingAverage, .slugging, .onBasePercentage, .hits, .atBats, .plateAppearances, .singles, .doubles, .triples, .homeRuns, .itpHRs, .grandSlams, .rbis, .walks, .strikeOuts, .reachOnError]
    
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
        case .hitByPitches:
            return "HBP"
        case .homeRuns:
            return "HR"
        case .itpHRs:
            return "HR(ITP)"
        case .onBasePercentage:
            return "OBP"
        case .plateAppearances:
            return "PA"
        case .rbis:
            return "RBIs"
        case .reachOnError:
            return "ROE"
        case .singles:
            return "1B"
        case .slugging:
            return "SLG"
        case .strikeOuts:
            return "K"
        case .triples:
            return "3B"
        case .walks:
            return "W"
        }
    }
    
    func displayString(isSingular: Bool = false) -> String {
        switch self {
        case .atBats:
            return isSingular ? "At Bat" : "At Bats"
        case .battingAverage, .onBasePercentage, .reachOnError, .slugging:
            return abbreviation
        case .doubles:
            return isSingular ? "Double" : "Doubles"
        case .gamesPlayed:
            return isSingular ? "Game" : "Games"
        case .grandSlams:
            return isSingular ? "Grand Slam" : "Grand Slams"
        case .hits:
            return isSingular ? "Hit" : "Hits"
        case .hitByPitches:
            return isSingular ? "Hit by Pitch" : "Hit by Pitches"
        case .homeRuns:
            return isSingular ? "Home Run" : "Home Runs"
        case .itpHRs:
            return isSingular ? "HR-ITP" : "HRs-ITP"
        case .plateAppearances:
            return isSingular ? "Plate Appearance" : "Plate Appearances"
        case .rbis:
            return isSingular ? "RBI" : "RBIs"
        case .singles:
            return isSingular ? "Single" : "Singles"
        case .strikeOuts:
            return isSingular ? "Strike Out" : "Strike Outs"
        case .triples:
            return isSingular ? "Triple" : "Triples"
        case .walks:
            return isSingular ? "Walk" : "Walks"
        }
    }
    
    func statValue(from atBats: [AtBat]) -> Double {
        switch self {
        case .atBats:
            return atBats.battingAverageCount.doubleValue
        case .battingAverage:
            guard atBats.battingAverageCount > 0 else { return 0 }
            let hits = atBats.hitCount.doubleValue
            return hits / atBats.battingAverageCount.doubleValue
        case .doubles:
            return atBats.withResult(.double).count.doubleValue
        case .gamesPlayed:
            return Set(atBats.map { $0.gameId }).count.doubleValue
        case .grandSlams:
            let hrs = atBats.withResults([.hr, .hrITP])
            return hrs.filter { $0.rbis == 4 }.count.doubleValue
        case .hits:
            return atBats.hitCount.doubleValue
        case .hitByPitches:
            return atBats.withResult(.hbp).count.doubleValue
        case .homeRuns:
            return atBats.withResults([.hr, .hrITP]).count.doubleValue
        case .itpHRs:
            return atBats.withResult(.hrITP).count.doubleValue
        case .onBasePercentage:
            guard atBats.count > 0 else { return 0 }
            let onBaseBatCount = atBats.filter { $0.resultCode.gotOnBase }.count.doubleValue
            return onBaseBatCount / atBats.count.doubleValue
        case .plateAppearances:
            return atBats.count.doubleValue
        case .rbis:
            return atBats.reduce(0, { $0 + $1.rbis }).doubleValue
        case .reachOnError:
            return atBats.withResult(.roe).count.doubleValue
        case .singles:
            return atBats.withResult(.single).count.doubleValue
        case .slugging:
            guard atBats.sluggingCount > 0 else { return 0 }
            return atBats.sluggingCount / atBats.battingAverageCount.doubleValue
        case .strikeOuts:
            return atBats.withResult(.k).count.doubleValue
        case .triples:
            return atBats.withResult(.triple).count.doubleValue
        case .walks:
            return atBats.withResult(.w).count.doubleValue
        }
    }
    
}
