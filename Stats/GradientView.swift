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
import QuartzCore

@IBDesignable class GradientView: UIView {

    // MARK: - Inspectable properties

    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet {
            setupView()
        }
    }

    @IBInspectable var isHorizontal: Bool = false {
        didSet {
            setupView()
        }
    }

    @IBInspectable var roundness: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }

    // MARK: - Overrides

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }

    // MARK: - Internal functions

    fileprivate func setupView() {
        let colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = roundness

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)

        if isHorizontal {
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else {
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }

        setNeedsDisplay()
    }

    // Helper to return the main layer as CAGradientLayer
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
