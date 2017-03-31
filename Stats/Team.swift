//
//  Team.swift
//  Stats
//
//  Created by Parker Rushton on 3/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import IGListKit
import Marshal

enum TeamSport: String {
    case baseball
    case fastPitch
    case slowPitch
}


struct Team: Marshaling, Unmarshaling {
    
    var id: String
    var currentSeasonId: String?
    var imageURLString: String?
    var name: String
    var shareCode: String
    var sport: TeamSport
    
    var imageURL: URL? {
        guard var imageURLString = imageURLString else { return nil }
        return URL(string: imageURLString)
    }
    
    init(id: String = "", currentSeasonId: String? =  nil, imageURLString: String? = nil, name: String, shareCode: String = "", sport: TeamSport) {
        self.id = id
        self.currentSeasonId = currentSeasonId
        self.imageURLString = imageURLString
        self.name = name
        self.shareCode = shareCode
        self.sport = sport
    }
    
    init(object: MarshaledObject) throws {
        id = object.value(for: idKey)
        currentSeasonId = object.value(for: currentSeasonIdKey)
        image = object.value(for: imageKey)
        name = object.value(for: nameKey)
        shareCode = object.value(for: shareCodeKey)
        sport = object.value(for: typeKey)
    }

    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[currentSeasonIdKey] = currentSeasonId
        json[imageURLStringKey] = imageURLString
        json[nameKey] = nameKey
        json[shareCodeKey] = shareCodeKey
        json[sportKey] = sport.rawValue
        
        return json
    }
    
}
