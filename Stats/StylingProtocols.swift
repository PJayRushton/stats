/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

// MARK: - Naming protocols

public protocol BackgroundColorNameable {
    var backgroundColorName: String? { get set }
}

public extension BackgroundColorNameable where Self: UIView {
    
    public func applyBackgroundColorName() {
        backgroundColor = UIColor(withName: backgroundColorName)
    }
    
}

public protocol DisabledBackgroundColorNameable {
    var backgroundColorName: String? { get set }
    var disabledBackgroundColorName: String? { get set }
}


public extension DisabledBackgroundColorNameable where Self: UIControl {
    
    public func updateBackgroundColor() {
        backgroundColor = UIColor(withName: isEnabled ? backgroundColorName : disabledBackgroundColorName)
    }
    
}

public protocol TintColorNameable {
    var tintColorName: String? { get set }
}

public extension TintColorNameable where Self: UIView {
    
    public func applyTintColorName() {
        tintColor = UIColor(withName: tintColorName)
    }
    
}

public protocol DisabledTintColorNameable {
    var tintColorName: String? { get set }
    var disabledTintColorName: String? { get set }

}


public extension DisabledTintColorNameable where Self: UIControl {
    
    public func updateTintColor() {
        tintColor = UIColor(withName: isEnabled ? tintColorName : disabledTintColorName)
    }
    
}

public protocol BorderColorNameable {
    var borderColorName: String? { get set }
}

public extension BorderColorNameable where Self: UIView {
    
    public func applyBorderColorName() {
        borderColor = UIColor(withName: borderColorName)
    }
    
}

public protocol DisabledBorderColorNameable {
    var borderColorName: String? { get set }
    var disabledBorderColorName: String? { get set }
}

public extension DisabledBorderColorNameable where Self: UIControl {
    
    public func updateBorderColor() {
        borderColor = UIColor(withName: isEnabled ? borderColorName : disabledBorderColorName)
    }
    
}

public protocol ShadowColorNameable {
    var shadowColorName: String? { get set }
}

public extension ShadowColorNameable where Self: UIView {
    
    public func applyShadowColorName() {
        shadowColor = UIColor(withName: shadowColorName)
    }
    
}

public protocol FontNameable: class {
    var fontName: String? { get set }
    var displayFont: UIFont? { get set }
}

public extension FontNameable {
    
    public func applyFontName() {
        if let fontName = fontName {
            displayFont = UIFont(named: fontName)
        }
    }
    
}

// MARK: - Circular view

protocol CircularView {
    var circular: Bool { get set }
}

extension CircularView where Self: UIView {
    
    func applyCircularStyleIfNeeded() {
        if circular {
            let minSideSize = min(frame.size.width, frame.size.height)
            layer.cornerRadius = minSideSize / 2.0
        }
    }
    
}
