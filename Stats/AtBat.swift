//
//  AtBat.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase
import Marshal

enum AtBatCode: String {
    case k
    case out
    case fc
    case sac
    case w
    case hbp
    case roe
    case single
    case double
    case triple
    case hrITP
    case hr
    
    var image: UIImage? {
        switch self {
        case .hrITP:
            return #imageLiteral(resourceName: "hr")
        default:
            return UIImage(named: rawValue)
        }
    }
    var selectedImage: UIImage? {
        switch self {
        case .hrITP:
            return #imageLiteral(resourceName: "hr-selected")
        default:
            return UIImage(named: "\(rawValue)-selected")
        }
    }
    var tintColor: UIColor {
        switch self {
        case .hbp, .w, .roe, .single, .double, .triple, .hr, .hrITP:
            return .mainAppColor
        case .k, .out, .sac, .fc:
            return .flatCoffee
        }
    }
    var isOut: Bool {
        return self == .k || self == .out || self == .sac || self == .fc || self == .sac
    }
    var isHit: Bool {
        return self == .single || self == .double || self == .triple || self == .hr || self == .hrITP
    }
    var countsForBA: Bool {
        return self != .w && self != .hbp && self != .sac
    }
    var isHR: Bool {
        return self == .hr || self == .hrITP
    }
    var gotOnBase: Bool {
        return isHit || self == .w || self == .hbp
    }
    
}

struct AtBat: Identifiable, Unmarshaling {
    
    var id: String
    var creationDate: Date
    var gameId: String
    var playerId: String
    var rbis: Int
    var resultCode: AtBatCode
    var seasonId: String
    var teamId: String
    
    init(id: String = "", creationDate: Date = Date(), gameId: String, playerId: String, rbis: Int = 0, resultCode: AtBatCode, seasonId: String, teamId: String) {
        self.id = id
        self.creationDate = creationDate
        self.gameId = gameId
        self.playerId = playerId
        self.rbis = rbis
        self.resultCode = resultCode
        self.seasonId = seasonId
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        creationDate = try object.value(for: creationDateKey)
        gameId = try object.value(for: gameIdKey)
        playerId = try object.value(for: playerIdKey)
        rbis = try object.value(for: rbisKey)
        resultCode = try object.value(for: resultCodeKey)
        seasonId = try object.value(for: seasonIdKey)
        teamId = try object.value(for: teamIdKey)
    }
    
}

extension AtBat: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[creationDateKey] = creationDate.iso8601String
        json[gameIdKey] = gameId
        json[playerIdKey] = playerId
        json[rbisKey] = rbis
        json[resultCodeKey] = resultCode.rawValue
        json[seasonIdKey] = seasonId
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension AtBat {
    
    var ref: DatabaseReference {
        return StatsRefs.atBatsRef(teamId: teamId).child(id)
    }
    
}

extension Int {
    
    var emojiString: String {
        switch self {
        case 0: return "0️⃣"
        case 1: return "1️⃣"
        case 2: return "2️⃣"
        case 3: return "3️⃣"
        case 4: return "4️⃣"
        case 5: return "5️⃣"
        case 6: return "6️⃣"
        case 7: return "7️⃣"
        case 8: return "8️⃣"
        case 9: return "9️⃣"
        case 10: return "🔟"
        default:
            fatalError()
        }
    }
    
}
