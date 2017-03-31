//
//  AddTeamToUser.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

enum TeamOwnershipType {
    case owned
    case managed
    case fan
}

struct AddTeamToUser: Command {
    
    var team: Team
    var type: TeamOwnershipType
    
    func execute(state: AppState, core: Core<AppState>) {
    }
}
