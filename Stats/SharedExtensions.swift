//
//  Arrays.swift
//  TeacherTools
//
//  Created by Parker Rushton on 10/30/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit
import Marshal

extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension Collection where Self: ExpressibleByDictionaryLiteral, Self.Key == String, Self.Value == Any {
    
    func parsedObjects<T: Identifiable>() -> [T] {
        guard let json = self as? JSONObject else { return [] }
        let keys = Array(json.keys)
        let objects: [JSONObject] = keys.compactMap { try? json.value(for: $0) }
        return objects.compactMap { try? T(object: $0) }
    }
    
}

extension Optional where Wrapped: MarshaledObject {
    
    func parsedObjects<T: Identifiable>() -> [T] {
        guard let json = self as? JSONObject else { return [] }
        let keys = Array(json.keys)
        let objects: [JSONObject] = keys.compactMap { try? json.value(for: $0) }
        return objects.compactMap { try? T(object: $0) }
    }
    
}

extension Array where Iterator.Element == Game {
    
    var record: TeamRecord {
        let wasWonBools = self.compactMap { $0.wasWon }
        let winCount = wasWonBools.filter { $0 == true }.count
        let lostCount = wasWonBools.filter { $0 == false }.count
        return TeamRecord(gamesWon: winCount, gamesLost: lostCount)
    }
    
}

extension Array where Iterator.Element == AtBat {

    func withResult(_ code: AtBatCode) -> [AtBat] {
        return filter { $0.resultCode == code }
    }
    
    func withResults(_ codes: [AtBatCode]) -> [AtBat] {
        return filter { codes.contains($0.resultCode) }
    }
    
    var hitCount: Int {
        return self.filter { $0.resultCode.isHit }.count
    }
    
    var battingAverageCount: Int {
        return self.filter { $0.resultCode.countsForBA }.count
    }
    var sluggingCount: Double {
        return reduce(0, { $0 + $1.sluggingValue })
    }
    
}

extension UUID {
    
    func userFacingCode() -> String {
        let unacceptableCharacters = CharacterSet(charactersIn: "0Oo1IiLl")
        let strippedString = self.uuidString.trimmingCharacters(in: unacceptableCharacters)
        return strippedString.last4
    }
    
}

extension String {
    
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }
    
//    subscript(r: Range<Int>) -> String {
//        let start = index(startIndex, offsetBy: r.lowerBound)
//        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
//        return String(self[Range(start ..< end)])
//    }
    
    var firstLetter: String {
        return self[0]
    }
    
    var last4: String {
        return String(suffix(4))
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
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
    
//    var jerseyNumberFontString: NSAttributedString {
//        let nsSelf = self as NSString
//        let firstRange = nsSelf.localizedStandardRange(of: "(")
//        let secondRange = nsSelf.localizedStandardRange(of: ")")
//        guard firstRange.length == 1 && secondRange.length == 1 else { return NSAttributedString(string: self) }
//
//        let length = secondRange.location - (firstRange.location + 1)
//        guard length > 0 else { return NSAttributedString(string: self) }
//        let numbersRange = NSRange(location: firstRange.location + 1, length: length)
//        let attributedString = NSMutableAttributedString(string: self)
//        attributedString.addAttributes([: FontType.jersey.font(withSize: 22)], range: numbersRange)
//
//        return attributedString
//    }
    
}

extension Double {
    
    var displayString: String {
        return String(format: "%.3f", self)
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

extension Int {
    
    static func random(_ range: Range<Int>) -> Int {
        return range.lowerBound + (Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))))
    }
    
    var randomDigitsString: String {
        guard self > 0 else { return "" }
        var digitsString = ""
        
        for _ in 0..<self {
            let newDigit = Int(arc4random_uniform(9))
            digitsString += String(newDigit)
        }
        return digitsString
    }
    
    var doubleValue: Double {
        return Double(self)
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
