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
    var touchDate: Date
    
    var imageURL: URL? {
        guard let imageURLString = imageURLString else { return nil }
        return URL(string: imageURLString)
    }
    var currentSeason: Season? {
        return App.core.state.seasonState.allSeasons.first(where: { $0.id == currentSeasonId })
    }
    
    init(id: String = "", currentSeasonId: String? =  nil, imageURLString: String? = nil, name: String, sport: TeamSport = .slowPitch) {
        self.id = id
        self.currentSeasonId = currentSeasonId
        self.imageURLString = imageURLString
        self.name = name
        self.shareCode = 4.randomDigitsString
        self.sport = sport
        self.touchDate = Date()
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        currentSeasonId = try? object.value(for: currentSeasonIdKey)
        imageURLString = try? object.value(for: imageURLStringKey)
        name = try object.value(for: nameKey)
        shareCode = try object.value(for: shareCodeKey)
        sport = try object.value(for: sportKey)
        touchDate = try object.value(for: touchDateKey)
    }
 
}

extension Team: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[currentSeasonIdKey] = currentSeasonId
        json[imageURLStringKey] = imageURLString ?? NSNull()
        json[nameKey] = name
        json[shareCodeKey] = shareCode
        json[sportKey] = sport.rawValue
        json[touchDateKey] = touchDate.iso8601String
        return json
    }
    
}


extension Team {
    
    var ref: FIRDatabaseReference {
        return StatsRefs.teamsRef.child(id)
    }
    
}
