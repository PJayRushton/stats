//
//  AppDelegate.swift
//  Stats
//
//  Created by Parker Rushton on 3/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var core = App.core
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        core.fire(command: LoadICloudUser())
        Appearance.setUp()
        Database.database().isPersistenceEnabled = true
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if core.state.userState.iCloudId == nil {
            core.fire(command: LoadICloudUser())
        }
    }

}
