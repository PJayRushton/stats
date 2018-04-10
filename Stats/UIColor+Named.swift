/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

extension UIColor {
    
    public convenience init?(withName name: String?) {
        guard let name = name else { return nil }
        let color = UIColor.value(forKey: name) as! UIColor
//        guard let actualColor = color else { return nil }
        self.init(cgColor: color.cgColor)
    }
    
}
