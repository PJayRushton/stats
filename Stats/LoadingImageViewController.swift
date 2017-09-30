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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainAppColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.rotate()
    }
    
    
    // MARK: - State Update
    
    override func update(with state: AppState) {
        if state.userState.iCloudQueried && state.userState.iCloudId == nil {
            presentICloudError()
        }
    }
    
}


// MARK: - Private

extension LoadingImageViewController {
    
    fileprivate func presentICloudError() {
        let alert = Presentr.alertViewController(title: "iCloud Error", body: "St@ syncs your data over iCloud. Check your phone's iCloud settings to continue")
        alert.addAction(AlertAction(title: "Open Settings", style: .cancel, handler: {
            self.openSettings()
        }))
        alert.addAction(AlertAction(title: "Try Again", style: .destructive, handler: {
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
