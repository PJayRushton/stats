//
//  Arrays.swift
//  TeacherTools
//
//  Created by Parker Rushton on 10/30/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import Marshal

extension Collection where Self: ExpressibleByDictionaryLiteral, Self.Key == String, Self.Value == Any {
    
    func parsedObjects<T: Identifiable>() -> [T] {
        guard let json = self as? JSONObject else { return [] }
        let keys = Array(json.keys)
        let objects: [JSONObject] = keys.flatMap { try? json.value(for: $0) }
        return objects.flatMap { try? T(object: $0) }
    }
    
}

extension Optional where Wrapped: MarshaledObject {
    
    func parsedObjects<T: Identifiable>() -> [T] {
        guard let json = self as? JSONObject else { return [] }
        let keys = Array(json.keys)
        let objects: [JSONObject] = keys.flatMap { try? json.value(for: $0) }
        return objects.flatMap { try? T(object: $0) }
    }
    
}

extension String {
    
    var last4: String {
        return self.substring(from:self.index(self.endIndex, offsetBy: -4))
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    static var seasonSuggestion: String {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        var season = ""
        
        switch currentMonth {
        case 0...5:
            season = "Spring"
        case 6...8:
            season = "Summer"
        case 9...12:
            season = "Fall"
        default:
            break
        }
        return "\(season) \(currentYear)"
    }
    
}

extension Array {
    
    func step(from: Index, to:Index, interval: Int = 1) -> Array<Element> {
        let strde = stride(from: from, to: to, by: interval)
        var arr = Array<Element>()
        for i in strde {
            arr.append(self[i])
        }
        return arr
    }
    
    func randomElement() -> Element? {
        guard self.count > 0 else { return nil }
        let randomIndex = Int.random(0..<self.count)
        return self[randomIndex]
    }
    
}

let array = [1,2,3,4,5,6]
let steps = array.step(from: array.startIndex, to:array.endIndex, interval: 2)

extension MutableCollection where Indices.Iterator.Element == Index {
    
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        guard count > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: count, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Int {
    
    static func random(_ range: Range<Int>) -> Int {
        return range.lowerBound + (Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))))
    }

}

extension Sequence where Iterator.Element == StringLiteralType {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        for value in self {
            json[value] = true
        }
        return json
    }
    
    func marshaledArray() -> JSONObject {
        var json = JSONObject()
        for (index, value) in enumerated() {
            json["\(index)"] = value
        }
        return json
    }
    
}

extension UIViewController {
    
    var embededInNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}

extension UIView {
    
    func rotate(duration: CFTimeInterval = 2, count: Float = Float.greatestFiniteMagnitude) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = count
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func fadeTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
    
}
