//
//  Team.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase
import IGListKit
import Marshal

enum TeamSport: Int {
    case baseball
    case fastPitch
    case slowPitch
    
    var stringValue: String {
        switch self {
        case .baseball:
            return "Baseball"
        case .fastPitch:
            return "Fastpitch"
        case .slowPitch:
            return "Slowpitch"
        }
    }
    
    static let allValues = [TeamSport.baseball, .fastPitch, .slowPitch]
}


struct Team: Identifiable, Unmarshaling {
    
    var id: String
    var currentSeasonId: String?
    var imageURLString: String?
    var name: String
    var shareCode: String
    var sport: TeamSport
    var normalDuration = 60 // Minutes
    
    var imageURL: URL? {
        guard let imageURLString = imageURLString else { return nil }
        return URL(string: imageURLString)
    }
    var currentSeason: Season? {
        return App.core.state.seasonState.seasons(for: self).first(where: { $0.id == currentSeasonId })
    }
    var isCoed: Bool {
        let teamPlayers = App.core.state.playerState.players(for: self)
        let genders = teamPlayers.map { $0.gender }
        return genders.contains(.male) && genders.contains(.female)
    }
    
    init(id: String = "", currentSeasonId: String? =  nil, imageURL: URL? = nil, name: String, sport: TeamSport = .slowPitch, normalDuration: Int = 60) {
        self.id = id
        self.currentSeasonId = currentSeasonId
        self.imageURLString = imageURL?.absoluteString
        self.name = name
        self.shareCode = 4.randomDigitsString
        self.sport = sport
        self.normalDuration = normalDuration
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        currentSeasonId = try? object.value(for: currentSeasonIdKey)
        imageURLString = try? object.value(for: imageURLStringKey)
        name = try object.value(for: nameKey)
        shareCode = try object.value(for: shareCodeKey)
        sport = try object.value(for: sportKey)
        normalDuration = try object.value(for: durationKey) ?? 60
    }
    
    func shareCodeString(ownershipType: TeamOwnershipType) -> String {
        return shareCode + String(ownershipType.hashValue)
    }
    
    func record(from games: [Game]) -> TeamRecord {
        let gamesWon = games.filter { $0.isCompleted && $0.wasWon! }.count
        let gamesLost = games.count - gamesWon
        return TeamRecord(gamesWon: gamesWon, gamesLost: gamesLost)
    }
    
}

extension Team: JSONMarshaling {

    func jsonObject() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[currentSeasonIdKey] = currentSeasonId
        json[imageURLStringKey] = imageURLString ?? NSNull()
        json[nameKey] = name
        json[shareCodeKey] = shareCode
        json[sportKey] = sport.rawValue
        json[durationKey] = normalDuration
        
        return json
    }
    
}

extension Team: Diffable {
    
    func isSame(as other: Team) -> Bool {
        return id == other.id &&
        imageURLString == other.imageURLString &&
        name == other.name &&
        sport == other.sport
    }
    
}

extension Team {
    
    var ref: DatabaseReference {
        return StatsRefs.teamsRef.child(id)
    }
    
}
