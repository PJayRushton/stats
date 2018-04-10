//
//  NotificationController.swift
//  Stats
//
//  Created by Parker Rushton on 9/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr
import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationController()
    let currentCenter = UNUserNotificationCenter.current()
    
    func getNotificationCenterAccessStatus(completion: @escaping (Bool?) -> Void) {
        currentCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .denied:
                completion(false)
            case .notDetermined:
                completion(nil)
            }
        }
    }
    
    func requestAccessIfNeeded(from: UIViewController) {
        getNotificationCenterAccessStatus { granted in
            if let _ = granted {
                return
            } else {
                DispatchQueue.main.async {
                    self.presentPreliminaryPermissionAlert(from: from)
                }
            }
        }
    }
    
    func presentPreliminaryPermissionAlert(from: UIViewController) {
        let alert = UIAlertController(title: "St@s would like to notify you of important team events!", message: "Like when games end or season stats are updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "👍", style: .default, handler: { _ in
            self.requestNotificationAccess()
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: .cancel, handler: nil))
        from.present(alert, animated: true, completion: nil)
    }
    
    func requestNotificationAccess(completion: ((Bool) -> Void)? = nil) {
        currentCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error == nil, granted {
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
}
