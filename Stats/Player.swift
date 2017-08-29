//
//  Player.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Firebase
import Marshal

struct Player: Identifiable, Unmarshaling {
    
    var id: String
    var gender: Gender
    var jerseyNumber: String?
    var name: String
    var order: Int
    var phone: String?
    var seasons = [String: Bool]()
    var teamId: String
    
    var displayName: String {
        guard isSubForCurrentSeason else { return name }
        return "*\(name)"
    }
    var phoneURL: URL? {
        guard let phone = phone, !phone.isEmpty else { return nil }
        return URL(string: "tel://\(phone.digits)")
    }
    var hasCellPhone: Bool {
        return phone != nil && phone!.isValidPhoneNumber
    }
    var isInCurrentSeason: Bool {
        guard let currentSeasonId = App.core.state.seasonState.currentSeasonId else { return false }
        return seasons.keys.contains(currentSeasonId)
    }
    var isSubForCurrentSeason: Bool {
        get {
            guard let currentSeason = App.core.state.seasonState.currentSeason else { return false }
            return isSub(for: currentSeason)
        }
        set {
            guard let currentSeason = App.core.state.seasonState.currentSeason else { return }
            seasons[currentSeason.id] = newValue
        }
    }

    init(id: String = "", name: String, jerseyNumber: String? = nil, isSub: Bool = false, phone: String? = nil, gender: Gender = .unspecified, teamId: String) {
        self.id = id
        self.name = name
        self.jerseyNumber = jerseyNumber
        if let currentSeasonId = App.core.state.seasonState.currentSeasonId {
            self.seasons = [currentSeasonId: isSub]
        } else {
            self.seasons = [:]
        }
        self.phone = phone
        self.order = App.core.state.playerState.players(for: teamId).count
        self.gender = gender
        self.teamId = teamId
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        gender = try object.value(for: genderKey)
        jerseyNumber = try object.value(for: jerseyNumberKey)
        name = try object.value(for: nameKey)
        order = try object.value(for: orderKey)
        phone = try object.value(for: phoneKey)
        if let seasonsObject: [String: Bool] = try object.value(for: seasonsRefKey) {
            seasons = seasonsObject
        } else if let currentTeam = App.core.state.teamState.currentTeam, let currentSeasonId = currentTeam.currentSeasonId {
            seasons = [currentSeasonId: false]
        } else {
            seasons = [:]
        }
        teamId = try object.value(for: teamIdKey)
    }
    
    func stat(ofType type: StatType, from atBats: [AtBat]) -> Stat {
        return Stat(playerId: id, type: type, value: type.statValue(from: atBats))
    }
    
    func isSub(for season: Season) -> Bool {
        return seasons[season.id] ?? false
    }
    
}

extension Player: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[genderKey] = gender.rawValue
        json[jerseyNumberKey] = jerseyNumber ?? NSNull()
        json[nameKey] = name
        json[orderKey] = order
        json[phoneKey] = phone ?? NSNull()
        var seasonsJSON = JSONObject()
        seasons.forEach { seasonsJSON[$0.key] = $0.value }
        json[seasonsKey] = seasonsJSON
        json[teamIdKey] = teamId
        
        return json
    }
    
}

extension Player: Diffable {
    
    func isSame(as other: Player) -> Bool {
        return id == other.id &&
        gender == other.gender &&
        seasons == other.seasons &&
        jerseyNumber == other.jerseyNumber &&
        name.lowercased() == other.name.lowercased() &&
        phone == other.phone
    }
    
}


extension Player {
    
    var ref: DatabaseReference {
        return StatsRefs.playersRef(teamId: teamId).child(id)
    }
    
}

extension Player: Comparable { }

func <(lhs: Player, rhs: Player) -> Bool {
    return lhs.name < rhs.name
}
