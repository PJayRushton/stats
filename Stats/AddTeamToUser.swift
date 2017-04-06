//
//  AddTeamToUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum TeamOwnershipType: Int {
    case owned
    case managed
    case fan
    
    var sectionTitle: String {
        switch self {
        case .owned:
            return NSLocalizedString("Coach", comment: "")
        case .managed:
            return NSLocalizedString("St@ Keeper", comment: "")
        case .fan:
            return NSLocalizedString("Player", comment: "")
        }
    }
    static let allValues = [TeamOwnershipType.owned, .managed, .fan]
}

struct AddTeamToUser: Command {
    
    var team: Team
    var type: TeamOwnershipType
    
    init(team: Team, type: TeamOwnershipType) {
        self.team = team
        self.type = type
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        guard var currentUser = state.userState.currentUser else { return }
        switch type {
        case .owned:
            currentUser.ownedTeamIds.insert(team.id)
        case .managed:
            currentUser.managedTeamIds.insert(team.id)
        case .fan:
            currentUser.managedTeamIds.insert(team.id)
        }
        let ref = StatsRefs.userRef(id: currentUser.id)
        networkAccess.updateObject(at: ref, parameters: currentUser.marshaled(), completion: nil)
    }
    
}
