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
//

import UIKit

class StatsPageViewController: UIPageViewController {

    var core = App.core

    let trophiesVC = StatsTrophiesViewController.initializeFromStoryboard()
    let numbersVC = StatsNumbersViewController.initializeFromStoryboard()
    
    var orderedViewControllers: [UIViewController] {
        return [trophiesVC, numbersVC]
    }

    var currentVCIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let firstViewController = orderedViewControllers.first else { return }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
        
}

extension StatsPageViewController: Subscriber {
    
    func update(with state: AppState) {
        let selectedTab = state.statState.currentViewType.rawValue
        let direction: UIPageViewControllerNavigationDirection = selectedTab > currentVCIndex ? .forward : .reverse
        let selectedViewController = orderedViewControllers[selectedTab]
        setViewControllers([selectedViewController], direction: direction, animated: true, completion: nil)
        currentVCIndex = selectedTab
    }

}
