//
//     /||\
//    / || \
//   /  )(  \
//  /__/  \__\
//


import Foundation
import UIKit

protocol ShadowableCell: class {}

extension ShadowableCell where Self: UICollectionViewCell {
    
    func addShadowToTop() {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: 1)).cgPath
        addShadow(with: path)
    }
    
    func addShadowToBottom() {
        let path = UIBezierPath(rect: CGRect(x: 0, y: bounds.height, width: bounds.width, height: 1)).cgPath
        addShadow(with: path)
    }
    
    func removeShadow() {
        layer.shadowPath = UIBezierPath(rect: .zero).cgPath
    }
    
}

private extension ShadowableCell where Self: UICollectionViewCell {
    
    func addShadow(with path: CGPath) {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2.0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = path
        clipsToBounds = false
    }
    
}

