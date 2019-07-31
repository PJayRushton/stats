//
//     /||\
//    / || \
//   /  )(  \
//  /__/  \__\
//

import UIKit

// MARK: - Font Constructable

protocol FontContructable {
    var fontFamily: String? { get }
    func preferredFont(forTextStyle textStyle: UIFontTextStyle, italicized: Bool) -> UIFont
    func font(ofSize size: CGFloat) -> UIFont
}


extension FontContructable {
    
    func preferredFont(forTextStyle textStyle: UIFontTextStyle, italicized: Bool = false) -> UIFont {
        if let fontFamilyName = fontFamily {
            return customFont(from: fontFamilyName, textStyle: textStyle, italicized: italicized)
        } else {
            let defaultDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
            return italicized ? UIFont.italicSystemFont(ofSize: defaultDescriptor.pointSize) : UIFont(descriptor: defaultDescriptor, size: 0)
        }
    }
    
    func font(ofSize size: CGFloat) -> UIFont {
        if let fontFamilyName = fontFamily {
            let descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: fontFamilyName])
            return UIFont(descriptor: descriptor, size: size)
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    private func customFont(from fontFamilyName: String, textStyle: UIFontTextStyle, italicized: Bool = false) -> UIFont {
        let defaultDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let customDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: fontFamilyName, UIFontDescriptor.AttributeName.family: fontFamilyName])
        let size = defaultDescriptor.pointSize
        
        if italicized {
            let italicDescriptor = customDescriptor.withSymbolicTraits(.traitItalic)!
            if defaultDescriptor.isBold {
                let boldDescriptor = italicDescriptor.withSymbolicTraits(.traitBold)!
                return UIFont(descriptor: boldDescriptor, size: size)
            }
            return UIFont(descriptor: italicDescriptor, size: size)
        }
        if defaultDescriptor.isBold {
            let boldDescriptor = customDescriptor.withSymbolicTraits(.traitBold)!
            return UIFont(descriptor: boldDescriptor, size: size)
        }
        
        return UIFont(descriptor: customDescriptor, size: size)
    }

    
}


extension UIFontDescriptor {
    
    var isBold: Bool {
        return symbolicTraits.contains(.traitBold)
    }
}


// MARK: - Trait

extension UIFont {
    
    /// The Trait of the Font
    ///
    /// - regular: the default font
    /// - italic: italic font
    /// - bold: bold font
    enum Trait {
        case regular
        case italic
        case bold
    }
    
    struct Courier: FontContructable {
        
        var fontFamily: String? {
            return "Courier"
        }
        
    }
    
    struct System: FontContructable {
        
        var fontFamily: String? {
            return nil
        }
        
    }
    
}


extension UIFont {
    
    static let appFont = system
    static let courier = Courier()
    static let system = System()


    /// Default Size: 34B
    static var largeTitle: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    /// Default Size: 28B
    static var title1: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .title1)
    }
    
    /// Default Size: 22B
    static var title2: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .title2)
    }
    
    /// Default Size: 20B
    static var title3: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .title3)
    }
    
    /// Default Size: 17
    static var body: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .body)
    }
    
    /// Default Size: 17I
    static var bodyItalic: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .body, italicized: true)
    }
    
    /// Default Size: 17B
    static var headline: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .headline)
    }
    
    /// Default Size: 17BI
    static var headlineItalic: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .headline, italicized: true)
    }
    
    /// Default Size: 16
    static var callout: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .callout)
    }
    
    /// Default Size: 15
    static var subhead: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .subheadline)
    }
    
    /// Default Size: 13
    static var footnote: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .footnote)
    }
    
    /// Default Size: 12B
    static var caption1: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .caption1)
    }
    
    /// Default Size: 11
    static var caption2: UIFont {
        return UIFont.appFont.preferredFont(forTextStyle: .caption2)
    }
    
    /// Courier: Body
    static var code: UIFont {
        return UIFont.courier.preferredFont(forTextStyle: .body)
    }
    
    
    // MARK: - Computed
    
    /// Style: Title3 (20B)
    static var title: UIFont {
        return title3
    }
    
    /// Style: Headline (17B)
    static var navTitle: UIFont {
        return headline
    }
    
    /// Style: Body (17)
    static var barButtonItem: UIFont {
        return body
    }
    
    /// Style: Callout (16)
    static var button: UIFont {
        return callout
    }
    
    /// Style: Callout (16)
    static var cellTitle: UIFont {
        return callout
    }

    /// Style: Caption1 (12B)
    static var sectionHeader: UIFont {
        return caption1
    }
    
    /// Style: Footnote (13)
    static var segmentedControl: UIFont {
        return footnote
    }
    
    /// Style: Caption2 (11)
    static var tabBarItem: UIFont {
        return caption2
    }
    
    /// Style: Caption2 (11)
    static var cellSubtitle: UIFont {
        return caption2
    }
    
}
