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

class Component: UIViewController, Subscriber {
    
    var core = App.core
    
    let alertPresenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
    
    func update(with: AppState) {
        // override me
    }
    
    func modalPresenter(withTransitionType transitionType: TransitionType = .coverHorizontalFromRight) -> Presentr {
        let customPresentation = PresentationType.custom(width: .half, height: .half, center: .center)
        let modalPresentation = PresentationType.popup
        
        let presentationType = UIDevice.current.userInterfaceIdiom == .pad ? customPresentation : modalPresentation
        let presenter = Presentr(presentationType: presentationType)
        presenter.transitionType = transitionType
        presenter.dismissTransitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }
    
}
