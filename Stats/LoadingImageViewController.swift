//
//        .........     .........
//      ......  ...........  .....
//      ...        .....       ....
//     ...         ....         ...
//     ...       ........        ...
//     ....      .... ....      ...
//      ...      .... ....      ...
//      .....     .......     ....
//        ...      .....     ....
//         ....             ....
//           ....         ....
//            .....     .....
//              .....  ....
//                .......
//                  ...

import UIKit
import Presentr

final class LoadingImageViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var atLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        atLabel.rotate()
    }
    
    override func update(with state: AppState) {
        if  state.userState.iCloudQueried && state.userState.iCloudId == nil {
            presentICloudError()
        }
    }
    
    fileprivate func presentICloudError() {
        let alert = Presentr.alertViewController(title: "iCloud Error", body: "St@ uses your iCloud account to facilitate data sync. Make sure you are logged in to iCloud in the settings app")
        alert.addAction(AlertAction(title: "⚙ Settings ⚙", style: .cancel, handler: {
            self.openSettings()
        }))
        alert.addAction(AlertAction(title: "🔄 Try again 🔄", style: .destructive, handler: {
            self.core.fire(command: LoadICloudUser())
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    
    fileprivate func openSettings() {
        let fakeSettingsURL = URL(string:"App-Prefs:")
        let realSettingsURL = URL(string: UIApplicationOpenSettingsURLString)
        if let url = fakeSettingsURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = realSettingsURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
