//
//  CSVExporter.swift
//  Stats
//
//  Created by Parker Rushton on 9/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct CSVExporter {
    
    static func csvDataPath(from stats: GameStats, state: AppState) -> String? {
        guard let team = state.teamState.currentTeam, let currentSeason = state.seasonState.currentSeason else { return nil }
        let csvText = csvString(from: stats, state: state)
        let path = NSTemporaryDirectory().appending("\(team.name)_Stats-\(currentSeason.name).csv")
        guard let pathURL = URL(fileURLWithPath: path) else { return nil }
        do {
            try csvText.write(to: pathURL, atomically: true, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    private static func csvString(from stats: GameStats, state: AppState) -> String {
        guard let team = state.teamState.currentTeam, let currentSeason = state.seasonState.currentSeason else { return "" }
        let gameCount = state.gameState.games(of: currentSeason).count
        var csv = "Team:,\(team.name)"
        if stats.isSeason {
            csv += "Season:,\(season.name)"
            csv += "Games Played:,\(gameCount)"
        } else if let game = state.gameState.game(withId: stats.gameId) {
            var gameDescription = "Game:,"
            if let index = state.gameState.order(of: game) {
                gameDescription += "\(index)"
            }
            gameDescription += " vs. \(game.opponent)--\(game.date.longStyleDateString)"
            csv += gameDescription
        }
        csv += "Exported:,\(Date().longStyleDateString)"
        csv += "\n\n"
        let abbreviations = StatType.allValues.map { $0.abbreviation }.joined(separator: ",")
        csv += "Player,\(abbreviations)"
        
        stats.stats.forEach { key, stats in
            guard let player = state.playerState.player(withId: key) else { return }
            var playerString = "\(player.name),"
            stats.forEach( { playerString += ", \($0.displayString)"})
            csv += playerString
        }
        
        return csv
    }
    
}
