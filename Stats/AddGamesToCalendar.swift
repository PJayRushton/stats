//
//  AddGamesToCalendar.swift
//  Stats
//
//  Created by Parker Rushton on 8/15/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import EventKit

struct CalendarHelper {
    
    static let shared = CalendarHelper()
    
    let eventStore = EKEventStore()
    
    var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func requestCalendarPermission(completion: @escaping (EKAuthorizationStatus) -> Void) {
        guard authorizationStatus != .authorized else { completion(.authorized); return }
        eventStore.requestAccess(to: .event) { (granted, error) in
            if error == nil && granted {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
    }
    
}

struct AddGamesToCalendar: Command {
    
    var games: [Game]
    
    private let calendarHelper = CalendarHelper.shared
    
    func execute(state: AppState, core: Core<AppState>) {
        calendarHelper.requestCalendarPermission { status in
            if status == .authorized {
                do {
                    let events = self.games.flatMap { $0.calendarEvent() }
                    try events.forEach { event in
                        try self.calendarHelper.eventStore.save(event, span: .thisEvent)
                    }
                } catch {
                    print("error saving event")
                }
            }
        }
    }
    
}
