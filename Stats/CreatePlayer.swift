//
//  CreatePlayer.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct CreatePlayer: Command {
    
    var player: Player
    
    init(_ player: Player) {
        self.player = player
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.addObject(at: player.ref, parameters: player.jsonObject()) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: "Error saving \(self.player.name)"))
            }
        }
    }
    
}
