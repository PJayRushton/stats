//
//  CSVExporter.swift
//  Stats
//
//  Created by Parker Rushton on 9/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveCurrentCSV: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        guard let stats = state.statState.currentStats, let team = state.teamState.currentTeam, let currentSeason = state.seasonState.currentSeason else { return }
        let csvText = csvString(from: stats, state: state)
        let path = NSTemporaryDirectory().appending("\(team.name)--Stats-\(currentSeason.name).csv")
        let pathURL = URL(fileURLWithPath: path)
        guard let objectId = state.statState.currentObjectId else { return }
        do {
            try csvText.write(to: pathURL, atomically: true, encoding: .utf8)
            core.fire(event: StatCSVPathUpdated(objectId: objectId, path: pathURL))
        } catch {
            core.fire(event: StatCSVPathUpdated(objectId: objectId, path: nil))
            dump(error)
        }
    }
    
    private func csvString(from stats: GameStats, state: AppState) -> String {
        guard let team = state.teamState.currentTeam, let season = state.seasonState.currentSeason else { return "" }
        let gameCount = state.gameState.games(of: season).count
        var csv = "Team:,\(team.name)\n"
        if stats.isSeason {
            csv += "Season:,\(season.name)\n"
            csv += "Games Played:,\(gameCount)\n"
        } else if let game = state.gameState.game(withId: stats.gameId) {
            var gameDescription = "Game:,"
            if let index = state.gameState.order(of: game) {
                gameDescription += "\(index)\n"
            }
            gameDescription += " vs. \(game.opponent)--\(game.date.mediumStyleDateString)\n"
            csv += gameDescription
        }
        csv += "Exported:,\(Date().mediumStyleDateString)\n"
        csv += "\n\n\n"
        csv += " , \n" // Empty Line
        let abbreviations = StatType.allValues.map { $0.abbreviation }.joined(separator: ",")
        csv += "Player,\(abbreviations)\n"
        
        let includeSubs = state.statState.includeSubs
        
        stats.stats.forEach { key, stats in
            guard let player = state.playerState.player(withId: key) else { return }
            if player.isSub(for: season) && !includeSubs {
                return
            }
            let playerString = "\(player.name),"
            let sortedStats = stats.customSorted()
            let sortedStatsString = sortedStats.map { $0.displayString}.joined(separator: ",")
            csv += playerString
            csv += sortedStatsString
            csv += "\n"
        }
        
        return csv
    }
    
}
