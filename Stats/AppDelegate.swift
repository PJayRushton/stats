//
//  AppDelegate.swift
//  Stats
//
//  Created by Parker Rushton on 3/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var core = App.core
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        if let iCloudId = currentUserCachedICloudId {
            core.fire(event: ICloudUserIdentified(iCloudId: iCloudId))
            core.fire(command: GetCurrentUser(iCloudId: iCloudId))
        } else {
            core.fire(command: GetICloudUser())
        }
        
        return true
    }

}
