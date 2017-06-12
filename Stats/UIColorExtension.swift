//
//  UIColorExtension.swift
//  TeacherTools
//
//  Created by Parker Rushton on 12/1/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import Marshal

extension UIColor {
    
    class var mainAppColor: UIColor {
        return UIColor.flatLimeDark
    }
    
    class var mainNavBarColor: UIColor {
        return .flatLimeDark
    }
    
    class var secondaryAppColor: UIColor {
        return .flatCoffeeDark
    }
    
    class var mainTextColor: UIColor {
        return .gray500
    }
    
    class var secondaryTextColor: UIColor {
        return .gray300
    }
    
    
    /// Hex: #F7F9FA
    class var gray100: UIColor { return #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 0.9803921569, alpha: 1) }
    
    /// Hex: #DADCDD
    class var gray200: UIColor { return #colorLiteral(red: 0.8545860648, green: 0.8627576232, blue: 0.8668149114, alpha: 1) }
    
    /// Hex: #A0A5A8
    class var gray300: UIColor { return #colorLiteral(red: 0.6268096566, green: 0.6469563246, blue: 0.6594427228, alpha: 1) }
    
    /// Hex: #52595C
    class var gray400: UIColor { return #colorLiteral(red: 0.3207190633, green: 0.3489254713, blue: 0.3615074456, alpha: 1) }
    
    /// Hex: #1A1E20
    class var gray500: UIColor { return #colorLiteral(red: 0.1055081859, green: 0.117551811, blue: 0.1259064078, alpha: 1) }
    
}

extension UIColor {

    convenience init(hex hexString: String) throws {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            throw MarshalError.nullValue(key: hexString)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}

extension MarshaledObject {
    
    public func value(for key: KeyType) throws -> UIColor {
        do {
            let stringValue: String = try self.value(for: key)
            return try UIColor(hex: stringValue)
        } catch MarshalError.nullValue {
            throw MarshalError.nullValue(key: key)
        }
    }
    
}
