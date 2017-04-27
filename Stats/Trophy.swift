//
//  Trophy.swift
//  Stats
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum Trophy {
    
    case battingAverage
    case hits
    case homeRuns
    case grandSlams
    case rbis
    case walks
    case onBasePercentage
    case reachedOnErrors
    case doubles
    case triples
    case worseBattingAverage
    
    static let allValues = [Trophy.battingAverage, .hits, .homeRuns, .grandSlams, .rbis, .walks, .onBasePercentage, .reachedOnErrors, .doubles, .triples, .worseBattingAverage]
    
    var displayName: String {
        switch self {
        case .battingAverage:
            return "🏆 MVP 🏆"
        case .hits:
            return "☠️ HITMAN ☠️"
        case .homeRuns:
            return "💣 LONG BOMBER 💣"
        case .grandSlams:
            return "🍗 SANDWICH MAKER 🍗"
        case .rbis:
            return "🏡 HIT ME IN! 🏡"
        case .walks:
            return "🤠WALKER TEXAS RANGER 🤠"
        case .onBasePercentage:
            return "😎 MR. RELIABLE 😎"
        case .reachedOnErrors:
            return "🦆 LUCKY DUCK 🦆"
        case .doubles:
            return "💥💥 DOUBLE TROUBLE 💥💥"
        case .triples:
            return "⚡️⚡️⚡️TRIPLE THREAT ⚡️⚡️⚡️"
        case .worseBattingAverage:
            return "😅 DON'T GIVE UP 😒"
        }
    }
    
    var subtitle: String {
        switch self {
        case .battingAverage:
            return "(Best Batting Average)"
        case .hits:
            return "(Most Hits)"
        case .homeRuns:
            return "(Most Home Runs)"
        case .grandSlams:
            return "(Most Grand Slams)"
        case .rbis:
            return "(Most RBIs)"
        case .walks:
            return "(Most Walks)"
        case .onBasePercentage:
            return "(Best On-Base Percentage)"
        case .reachedOnErrors:
            return "(Most Bases Reached On Errors)"
        case .doubles:
            return "(Most Doubles)"
        case .triples:
            return "(Most Triples)"
        case .worseBattingAverage:
            return "(Lowest Batting Average)"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .battingAverage:
            return UIColor.mainAppColor
        case .hits:
            return UIColor.mainAppColor
        case .homeRuns:
            return UIColor.mainAppColor
        case .grandSlams:
            return UIColor.mainAppColor
        case .rbis:
            return UIColor.mainAppColor
        case .walks:
            return UIColor.mainAppColor
        case .onBasePercentage:
            return UIColor.mainAppColor
        case .reachedOnErrors:
            return UIColor.mainAppColor
        case .doubles:
            return UIColor.mainAppColor
        case .triples:
            return UIColor.mainAppColor
        case .worseBattingAverage:
            return UIColor.mainAppColor
        }
    }
    
    var statType: StatType {
        switch self {
        case .battingAverage:
            return .battingAverage
        case .hits:
            return .hits
        case .homeRuns:
            return .homeRuns
        case .grandSlams:
            return .grandSlams
        case .rbis:
            return .rbis
        case .walks:
            return .walks
        case .onBasePercentage:
            return .onBasePercentage
        case .reachedOnErrors:
            return .reachOnError
        case .doubles:
            return .doubles
        case .triples:
            return .triples
        case .worseBattingAverage:
            return .battingAverage
        }
    }

}
