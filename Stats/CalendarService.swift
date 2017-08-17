//
//     /||\
//    / || \
//   /  )(  \
//  /__/  \__\
//

import Foundation
import UIKit
import EventKit

struct CalendarService {
    
    static let eventStore = EKEventStore()
    
    ///  Checks calendar permissions and prompts the user to open settings if needed.
    ///
    /// - Parameter viewController: Source view controller to use in presenting the alert
    /// - Returns: `true` if alert is presented.
    @discardableResult static func needsToShowCalendarDeniedAlert(from viewController: UIViewController) -> Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            return false
        case .denied, .restricted:
            viewController.present(permissionAlert, animated: true, completion: nil)
            return true
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                self.needsToShowCalendarDeniedAlert(from: viewController)
            })
            return true
        }
    }
    static func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            completion(granted)
        }
    }
    
    static var hasCalendarPermission: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    private static var permissionAlert: UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("Permission needed", comment: "Alert title that calendar permissions are needed"), message: NSLocalizedString("In order to create a calendar event, you need to grant the app permission to access your calendar.", comment: "Alert explanation for calendar permissions needed"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.cancel)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Settings", comment: "Button title to open Settings app"), style: .default) { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        })
        return alert
    }
    
}

struct ProcessGamesForCalendar: Command {
    
    var viewController: UIViewController
    var completion: ((CalendarGames) -> Void)?
    
    init(from viewController: UIViewController, completion: ((CalendarGames) -> Void)? = nil) {
        self.viewController = viewController
        self.completion = completion
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        guard CalendarService.hasCalendarPermission && !CalendarService.needsToShowCalendarDeniedAlert(from: viewController) else { return }
        let currentGames = state.gameState.currentGames
        let saveGames = currentGames.filter { $0.calendarId == nil }
        let calendarIdGames = currentGames.filter { $0.calendarId != nil }
        let dirtyCalendarGames = calendarIdGames.filter { game in
            guard let savedEvent = CalendarService.eventStore.event(withIdentifier: game.calendarId!) else { return false }
            return !savedEvent.isSame(as: game.calendarEvent())
        }
        let calendarGames = CalendarGames(gamesToSave: saveGames, gamesToEdit: dirtyCalendarGames)
        core.fire(event: Updated<CalendarGames>(calendarGames))
        completion?(calendarGames)
    }

}
