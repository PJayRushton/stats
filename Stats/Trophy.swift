//
//  Trophy.swift
//  Stats
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

enum Trophy: Int {
    
    case battingAverage
    case hits
    case slugger
    case homeRuns
    case inTheParkers
    case grandSlams
    case rbis
    case walks
    case hitByPitches
    case onBasePercentage
    case reachedOnErrors
    case singles
    case doubles
    case triples
    case worseBattingAverage
    
    static let allValues = [Trophy.battingAverage, .hits, .slugger, .homeRuns, .inTheParkers, .grandSlams, .rbis, .walks, .onBasePercentage, .reachedOnErrors, .singles, .doubles, .triples, .worseBattingAverage]
    
    var displayName: String {
        switch self {
        case .battingAverage:
            return "🏆 MVP 🏆"
        case .hits:
            return "☠️ HITMAN ☠️"
        case .slugger:
            return "💪 LOUSVILLE SLUGGER 💪"
        case .homeRuns:
            return "💣 LONG BOMBER 💣"
        case .inTheParkers:
            return "👟 HIT & RUN 🏃"
        case .grandSlams:
            return "🍗 SALAMI SANDWICH MAKER 🍗"
        case .rbis:
            return "🏠 HIT ME IN! 🏠"
        case .walks:
            return "🤠 WALKER TEXAS RANGER 🤠"
        case .hitByPitches:
            return "⚾️ PITCH SLAPPED 🤕"
        case .onBasePercentage:
            return "😎 MR(S). RELIABLE 😎"
        case .reachedOnErrors:
            return "🦆 LUCKY DUCK 🦆"
        case .singles:
            return "💍 ALL YOU SINGLE LADIES 💍"
        case .doubles:
            return "💥💥 DOUBLE TROUBLE 💥💥"
        case .triples:
            return "⚡️⚡️⚡️TRIPLE THREAT ⚡️⚡️⚡️"
        case .worseBattingAverage:
            return "😅 DON'T GIVE UP 😞"
        }
    }
    
    var subtitle: String {
        switch self {
        case .battingAverage:
            return "(Best Batting Average)"
        case .hits:
            return "(Most Hits)"
        case .slugger:
            return "(Best Slugging Percentage)"
        case .homeRuns:
            return "(Most Home Runs)"
        case .inTheParkers:
            return "(Most In-The-Park HRs)"
        case .grandSlams:
            return "(Most Grand Slams)"
        case .rbis:
            return "(Most RBIs)"
        case .walks:
            return "(Most Walks)"
        case .hitByPitches:
            return "(Most Times Hit By Pitch)"
        case .onBasePercentage:
            return "(Best On-Base Percentage)"
        case .reachedOnErrors:
            return "(Most Bases Reached On Errors)"
        case .singles:
            return "(Most Singles)"
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
            return .mainAppColor
        case .hits:
            return .flatBlack
        case .slugger:
            return .flatSkyBlue
        case .homeRuns:
            return .flatRed
        case .inTheParkers:
            return .flatTeal
        case .grandSlams:
            return .flatOrange
        case .rbis:
            return .mainAppColor
        case .walks:
            return .flatBlack
        case .hitByPitches:
            return .flatSkyBlue
        case .onBasePercentage:
            return .flatRed
        case .reachedOnErrors:
            return .flatTeal
        case .singles:
            return .flatOrange
        case .doubles:
            return .mainAppColor
        case .triples:
            return .flatBlack
        case .worseBattingAverage:
            return .flatSkyBlue
        }
    }
    
    var statType: StatType {
        switch self {
        case .battingAverage:
            return .battingAverage
        case .hits:
            return .hits
        case .slugger:
            return .slugging
        case .homeRuns:
            return .homeRuns
        case .inTheParkers:
            return .itpHRs
        case .grandSlams:
            return .grandSlams
        case .rbis:
            return .rbis
        case .walks:
            return .walks
        case .hitByPitches:
            return .hitByPitches
        case .onBasePercentage:
            return .onBasePercentage
        case .reachedOnErrors:
            return .reachOnError
        case .singles:
            return .singles
        case .doubles:
            return .doubles
        case .triples:
            return .triples
        case .worseBattingAverage:
            return .battingAverage
        }
    }

}
