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

class MainViewController: Component {

    fileprivate let homeVC = HomeViewController.initializeFromStoryboard().embededInNavigationController
    fileprivate let loadingImageVC = LoadingImageViewController.initializeFromStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        let userState = state.userState
        
        if let _ = userState.iCloudId, userState.isLoaded, state.teamState.isSubscribed {
            if let currentUser = userState.currentUser, !currentUser.allTeamIds.isEmpty, state.teamState.currentTeam == nil {
                showLoadingScreen()
            } else {
                presentApplication()
            }
        } else {
            showLoadingScreen()
        }
    }
    
}

extension MainViewController {
    
    fileprivate func presentApplication() {
        loadingImageVC.removeFromParentViewController()
        loadingImageVC.view.removeFromSuperview()
        
        addChildViewController(homeVC)
        view.addSubview(homeVC.view)
    }

    fileprivate func showLoadingScreen() {
        homeVC.removeFromParentViewController()
        if let index = view.subviews.index(of: loadingImageVC.view) {
            view.bringSubview(toFront: view.subviews[index])
        } else {
            addChildViewController(loadingImageVC)
            view.addSubview(loadingImageVC.view)
        }
    }
    
}
