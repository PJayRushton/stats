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
    case onBasePercentage
    case rbis
    case reachOnError
    case singles
    case strikeOuts
    case triples
    case walks
    
    static let allValues = [StatType.battingAverage, .onBasePercentage, .hits, .atBats, .singles, .doubles, .triples, .homeRuns, .grandSlams, .rbis, .walks, .strikeOuts, .reachOnError]
    
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
    
    func displayString(singular: Bool = false) -> String {
        switch self {
        case .atBats:
            return singular ? "At Bat" : "At Bats"
        case .battingAverage:
            return "BA"
        case .doubles:
            return singular ? "Double" : "Doubles"
        case .gamesPlayed:
            return singular ? "Game" : "Games"
        case .grandSlams:
            return singular ? "Grand Slam" : "Grand Slams"
        case .hits:
            return singular ? "Hit" : "Hits"
        case .homeRuns:
            return singular ? "Home Run" : "Home Runs"
        case .onBasePercentage:
            return "OBP"
        case .rbis:
            return singular ? "RBI" : "RBIs"
        case .reachOnError:
            return "Reached on Error"
        case .singles:
            return singular ? "Single" : "Singles"
        case .strikeOuts:
            return singular ? "Strike Out" : "Strike Outs"
        case .triples:
            return singular ? "Triple" : "Triples"
        case .walks:
            return singular ? "Walk" : "Walks"
        }
    }
    
    func statValue(with atBats: [AtBat]) -> Double {
        switch self {
        case .atBats:
            return atBats.count.doubleValue
        case .battingAverage:
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
        case .onBasePercentage:
            let onBaseBatCount = atBats.filter { $0.resultCode.gotOnBase }.count.doubleValue
            return onBaseBatCount / atBats.count.doubleValue
        case .rbis:
            return atBats.reduce(0, { $0 + $1.rbis }).doubleValue
        case .reachOnError:
            return atBats.withResult(.roe).count.doubleValue
        case .singles:
            return atBats.withResult(.single).count.doubleValue
        case .strikeOuts:
            return atBats.withResult(.k).count.doubleValue
        case .triples:
            return atBats.withResult(.triple).count.doubleValue
        case .walks:
            return atBats.withResult(.w).count.doubleValue
        }
    }
    
    func allStats(with atBats: [AtBat]) -> [Stat] {
        let playerIds = Set(atBats.map { $0.playerId })
        
        var playerStats = [Stat]()
        playerIds.forEach { playerId in
            guard let player = playerId.statePlayer else { return }
            let playerAtBats = atBats.filter { $0.playerId == playerId }
            let statValue = self.statValue(with: playerAtBats)
            let playerStat = Stat(player: player, statType: self, value: statValue)
            playerStats.append(playerStat)
        }
        return playerStats
    }
    
}
