//
//  SaveCurrentTrophiesCSV.swift
//  Stats
//
//  Created by Parker Rushton on 9/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct SaveCurrentTrophiesCSV: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        DispatchQueue.main.async {
            guard let team = state.teamState.currentTeam, let currentSeason = state.seasonState.currentSeason else { return }
            var currentObjectDescription = currentSeason.name
            if let currentGame = state.statState.currentGame {
                currentObjectDescription = "Game \(state.gameState.order(of: currentGame)!) vs. \(currentGame.opponent)"
            }
            
            let csvText = self.csvString(from: state.statState.currentTrophies, state: state)
            let path = NSTemporaryDirectory().appending("\(team.name)--Trophies-\(currentObjectDescription).csv")
            let pathURL = URL(fileURLWithPath: path)
            guard let objectId = state.statState.currentObjectId else { return }
            do {
                try csvText.write(to: pathURL, atomically: true, encoding: .utf8)
                core.fire(event: TrophyCSVPathUpdated(objectId: objectId, path: pathURL))
            } catch {
                core.fire(event: TrophyCSVPathUpdated(objectId: objectId, path: nil))
                dump(error)
            }
        }
    }
    
    private func csvString(from trophies: [TrophySection], state: AppState) -> String {
        guard let team = state.teamState.currentTeam, let season = state.seasonState.currentSeason else { return "" }
        let gameCount = state.gameState.games(of: season).count
        var csv = "Team:,\(team.name)\n"
        if state.statState.currentGame == nil {
            csv += "Season:,\(season.name)\n"
            csv += "Games Played:,\(gameCount)\n"
        } else if let game = state.statState.currentGame {
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
        
        trophies.forEach { trophy in
            csv += trophy.trophy.displayName
            csv += "\n"
            csv += "1. \(trophy.displayString(stat: trophy.firstStat))"
            if let secondStat = trophy.secondStat {
                csv += ","
                csv += "2. \(trophy.displayString(stat: secondStat))"
                csv += "\n"
            } else {
                csv += "\n"
                return
            }
        }
        
        return csv
    }
    
}
