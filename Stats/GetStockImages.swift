//
//  GetStockImages.swift
//  Stats
//
//  Created by Parker Rushton on 5/18/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct GetStockImages: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.stockRef
        ref.observeSingleEvent(of: .value, with: { snap in
            if let urlStrings = snap.value as? [String] {
                let urls = urlStrings.flatMap(URL.init)
                core.fire(event: Updated<[URL]>(urls))
            }
        })
    }
    
}
