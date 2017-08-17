//
//  AddGamesToCalendar.swift
//  Stats
//
//  Created by Parker Rushton on 8/15/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import EventKit

struct AddGamesToCalendar: Command {
    
    var games: [Game]
    
    init(_ games: [Game]) {
        self.games = games
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        do {
            try games.forEach { game in
                let calendarEvent = game.calendarEvent()
                try CalendarService.eventStore.save(calendarEvent, span: .thisEvent)
                core.fire(command: UpdateGame(game, calendarId: calendarEvent.eventIdentifier))
            }
        } catch {
            print("error saving event")
        }
    }
    
}

struct EditCalendarEventForGames: Command {
    
    var games: [Game]
    
    init(_ games: [Game]) {
        self.games = games
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        games.forEach { game in
            guard let calendarId = game.calendarId, let event = CalendarService.eventStore.event(withIdentifier: calendarId) else { return }
            let updatedEvent = game.calendarEvent(from: event)
            do {
                try CalendarService.eventStore.save(updatedEvent, span: .thisEvent)
            } catch {
                print("error saving event to calendar")
            }
        }
    }

}

extension EKEvent: Diffable {
    
    func isSame(as other: EKEvent) -> Bool {
        return startDate == other.startDate &&
        location == other.location &&
        calendar == other.calendar &&
        endDate == other.endDate &&
        title == other.title
    }
    
}
