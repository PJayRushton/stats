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
        core.fire(command: LoadICloudUser())
        Appearance.setUp()
        FIRDatabase.database().persistenceEnabled = true
        
        let one = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock1.jpg?alt=media&token=65473ae7-c16f-4655-99dd-57e792ee7e91"
        let two = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock2.jpg?alt=media&token=5b00a78d-87d3-445b-ad4d-dbcb45c57a39"
        let three = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock3.jpg?alt=media&token=ef3f25d8-7130-4afb-89e4-011aa65f9ec0"
        let four = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock4.jpg?alt=media&token=d9f3736a-d846-444b-badd-69090b38f915"
        let five = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock5.jpg?alt=media&token=3e02c9e9-0ca1-47a1-9a8b-b4780732f3e4"
        let six = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock6.jpg?alt=media&token=212a0531-e20c-4f10-9222-90af137650a3"
        let seven = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock7.jpg?alt=media&token=66903590-062c-49b1-b45c-62bc0050e95d"
        let eight = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock8.jpg?alt=media&token=7c1f5429-e26d-4564-84b9-03a34d8e58a4"
        let nine = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock9.jpg?alt=media&token=68d3ffda-8c5b-48d0-a3ce-85487dd7a211"
        let ten = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock10.jpg?alt=media&token=76e5fefb-30df-404a-86aa-f1c1e5053ac6"
        let eleven = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock11.jpg?alt=media&token=9dc481a9-9c05-4805-94ed-62b08f4970cb"
        let twelve = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock12.jpg?alt=media&token=2f980eb1-2a22-46bc-adef-b56e983fbc1d"
        let thirteen = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock13.jpg?alt=media&token=018ef45a-1a9e-497f-9108-75528904a438"
        let fourteen = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock14.jpg?alt=media&token=9416043b-0d66-4cad-87c5-bdfb4aeb9097"
        let fifteen = "https://firebasestorage.googleapis.com/v0/b/stats-b2417.appspot.com/o/stock%2Fstock15.jpg?alt=media&token=05a95a26-68a8-4132-a7e2-0338fb41db55"
        let all = [one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen]
        
        let ref = StatsRefs.stockRef
        ref.updateChildValues(all.marshaledArray())
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if core.state.userState.iCloudId == nil {
            core.fire(command: LoadICloudUser())
        }
    }

}
