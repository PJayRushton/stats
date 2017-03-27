//
//  AppDelegate.swift
//  Stats
//
//  Created by Parker Rushton on 3/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var core = App.core
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        core.fire(command: GetCurrentUser())
        
        return true
    }

}
