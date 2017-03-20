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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        return true
    }

}
