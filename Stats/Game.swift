//
//  Game.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import EventKit
import Firebase
import Marshal

struct Game: Identifiable, Unmarshaling, DateComparable {

    var id: String
    var calendarId: String?
    var date: Date
    var inning: Int
    var isCompleted: Bool
    var isHome: Bool
    var isRegularSeason: Bool
    var lineupIds: [String]
    var location: String?
    var opponent: String
    var opponentScore: Int
    var outs = 0
    var score: Int
    var seasonId: String
    var teamId: String

    init(id: String = "", date: Date, inning: Int = 1, isCompleted: Bool = false, isHome: Bool, isRegularSeason: Bool = true, lineupIds: [String] = [], location: String? = nil, opponent: String, opponentScore: Int = 0, outs: Int = 0, score: Int = 0, seasonId: String, teamId: String) {
        self.id = id
        self.date = date
        self.inning = inning
        self.isCompleted = isCompleted
        self.isHome = isHome
        self.isRegularSeason = isRegularSeason
        self.lineupIds = lineupIds
        self.location = location
        self.opponent = opponent
        self.opponentScore = opponentScore
        self.outs = outs
        self.score = score
        self.seasonId = seasonId
        self.teamId = teamId
    }
    
    var wasWon: Bool? {
        guard opponentScore != score && isCompleted else { return nil }
        return score > opponentScore
    }

    var scoreString: String {
        let firstScore = isHome ? opponentScore : score
        let secondScore = isHome ? score : opponentScore
        return "\(firstScore) - \(secondScore)"
    }
    
    var status: String {
        if isCompleted {
            guard let wasWon = wasWon else { return "🚫" }
            return wasWon ? "W" : "L"
        } else {
            let inningPrefix = isHome ? "⬇" : "⬆"
            return "\(inningPrefix) \(inning)"
        }
    }
    var lineup: [Player] {
        return lineupIds.compactMap { App.core.state.playerState.player(withId: $0) }
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        calendarId = try object.value(for: calendarIdKey)
        date = try object.value(for: dateKey)
        inning = try object.value(for: inningKey)
        isCompleted = try object.value(for: isCompletedKey)
        isHome = try object.value(for: isHomeKey)
        isRegularSeason = try object.value(for: isRegularSeasonKey)
        lineupIds = try object.value(for: lineupKey) ?? []
        location = try object.value(for: locationKey)
        opponent = try object.value(for: opponentKey)
        opponentScore = try object.value(for: opponentScoreKey)
        outs = try object.value(for: outsKey) ?? 0
        score = try object.value(for: scoreKey)
        seasonId = try object.value(for: seasonIdKey)
        teamId = try object.value(for: teamIdKey)
    }
    
}

extension Game: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[calendarIdKey] = calendarId
        json[dateKey] = date.iso8601String
        json[inningKey] = inning
        json[isCompletedKey] = isCompleted
        json[isHomeKey] = isHome
        json[isRegularSeasonKey] = isRegularSeason
        json[lineupKey] = lineupIds.marshaledArray()
        json[locationKey] = location
        json[opponentKey] = opponent
        json[opponentScoreKey] = opponentScore
        json[outsKey] = outs
        json[scoreKey] = score
        json[seasonIdKey] = seasonId
        json[teamIdKey] = teamId
        
        return json
    }
    
}


// MARK: - Diffable

extension Game: Diffable {
    
    func isSame(as other: Game) -> Bool {
        return id == other.id &&
            date == other.date &&
            isHome == other.isHome &&
            isRegularSeason == other.isRegularSeason &&
            opponent == other.opponent &&
            lineupIds == other.lineupIds &&
            location == other.location
    }
    
}


// MARK: - Identifiable

extension Game {
    
    var ref: DatabaseReference {
        return StatsRefs.gamesRef(teamId: teamId).child(id)
    }
    
}

extension Game {
    
    func calendarEvent(from event: EKEvent? = nil) -> EKEvent {
        let event =  event ?? EKEvent(eventStore: CalendarService.eventStore)
        event.startDate = date
        event.location = location
        event.calendar  = CalendarService.eventStore.defaultCalendarForNewEvents
        guard let team = App.core.state.teamState.currentTeam else { return event }
        let endDate = Calendar.current.date(byAdding: .minute, value: team.normalDuration, to: date)!
        event.endDate = endDate
        let homeAwayString = isHome ? "Home" : "Visitor"
        event.title = "\(team.name) game against \(opponent) - \(homeAwayString)"
        
        return event
    }
    
}
