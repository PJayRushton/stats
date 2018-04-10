//
//     /||\
//    / || \
//   /  )(  \
//  /__/  \__\
//

import UIKit
import Marshal

extension UIColor {
    
    convenience init?(named: String?) {
        guard let name = named,
            let color = UIColor.value(forKey: name) as? UIColor else {
            return nil
        }
        self.init(cgColor: color.cgColor)
    }
    
    
    // MARK: - App colors
    
    static var mainAppColor: UIColor {
        return green2
    }
    
    static var mainNavBarColor: UIColor {
        return green2
    }
    
    static var secondaryAppColor: UIColor {
        return secondaryAction
    }
    
    static var primaryAction: UIColor {
        return green2
    }
    
    static var secondaryAction: UIColor {
        return flatCoffee
    }
    
    static var primaryActionLight: UIColor {
        return UIColor.primaryAction.withAlphaComponent(0.2)
    }
    
    static var primaryActionMid: UIColor {
        return UIColor.primaryAction.withAlphaComponent(0.5)
    }
    
    static var primaryText: UIColor {
        return .gray2
    }
    
    static var secondaryText: UIColor {
        return .gray1
    }
    
    static var lightText: UIColor {
        return .white
    }
    
    static var icon: UIColor {
        return .gray2
    }
    
    static var inactiveAction: UIColor {
        return .gray1
    }
    
    static var borderStroke: UIColor {
        return .gray1
    }
    
    static var backgroundFill: UIColor {
        return .lightGray
    }
    
    static var darkerBackground: UIColor {
        return .gray1
    }
    
    static var avatarBackground: UIColor {
        return .gray1
    }
    
    static var lightBackground: UIColor {
        return .white
    }
    
    static var navBackground: UIColor {
        return .blue2
    }
    
    static var navTint: UIColor {
        return .lightText
    }
    
    static var navTintDisabled: UIColor {
        return UIColor.navTint.withAlphaComponent(0.4)
    }
    
    static var error: UIColor {
        return .red2
    }
    
    static var destructive: UIColor {
        return .red2
    }
    
    static var information: UIColor {
        return .blue2
    }
    
    static var cellHighlight: UIColor {
        return UIColor.primaryAction.withAlphaComponent(0.3)
    }
    
    static var modalBackground: UIColor {
        return UIColor(white: 0.0, alpha: 0.4)
    }
    
    static var darkShadow: UIColor {
        return flatBlack
    }
    
    static var transparent: UIColor {
        return .clear
    }
    
    
    // Alerts
    
    static var infoAlertBackground: UIColor {
        return .blue1
    }
    
    static var infoAlertBorder: UIColor {
        return .blue2
    }
    
    static var errorAlertBackground: UIColor {
        return .red1
    }
    
    static var errorAlertText: UIColor {
        return .red2
    }
    
    static var errorAlertBorder: UIColor {
        return .red2
    }
    
    static var success: UIColor {
        return .green1
    }
    
    static var successAlertBackground: UIColor {
        return .green1
    }
    
    static var successAlertText: UIColor {
        return .green1
    }
    
    static var successAlertBorder: UIColor {
        return .green2
    }
    
    static var warningAlertBackground: UIColor {
        return .yellow1
    }
    
    static var warningAlertText: UIColor {
        return .yellow2
    }
    
    static var warningAlertBorder: UIColor {
        return .yellow2
    }
    
    static var warning: UIColor {
        return .yellow2
    }
    
}


// MARK: - Source

extension UIColor {
    
    
    // MARK: - Blues
    
    /// #2B2B2B
    static var blue1: UIColor {
        return flatBlue
    }
    
    /// #9AACD6
    static var blue2: UIColor {
        return flatBlueDark
    }
    
    
    // MARK: - Greens
    
    /// #A6C63B
    static var green1: UIColor {
        return flatLime
    }
    
    /// #8EB021
    static var green2: UIColor {
        return UIColor(named: #function)!
    }
    
    
    // MARK: - Yellows
    
    /// #FFCC02
    static var yellow1: UIColor {
        return flatYellow
    }
    
    /// #FFAA00
    static var yellow2: UIColor {
        return flatYellowDark
    }

    
    // MARK: - Reds
    
    /// #E84D3C
    static var red1: UIColor {
        return flatRed
    }
    
    /// #BF382A
    static var red2: UIColor {
        return flatRedDark
    }
    
    
    // MARK: - Grays
    
//    /// #F6F9FA
//    static var gray0: UIColor {
//        return UIColor(named: #function)!
//    }
    
    /// #95A4A5
    static var gray1: UIColor {
        return flatGray
    }
    
    /// #7E8B8C
    static var gray2: UIColor {
        return flatGrayDark
    }
    
}

extension MarshaledObject {
    
    public func value(for key: KeyType) throws -> UIColor {
        do {
            let stringValue: String = try self.value(for: key)
            return try UIColor(hexString: stringValue)
        } catch MarshalError.nullValue {
            throw MarshalError.nullValue(key: key)
        }
    }
    
}
