//
//  GetQuotes.swift
//  Stats
//
//  Created by Parker Rushton on 5/10/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Marshal

struct GetQuotes: Command {
    
    func execute(state: AppState, core: Core<AppState>) {
        let ref = StatsRefs.quotesRef
        networkAccess.getData(at: ref) { result in
            let quotesResult = result.map { (json: JSONObject) -> [Quote] in
                return json.parsedObjects()
            }
            switch quotesResult {
            case let .success(quotes):
                core.fire(event: Updated<[Quote]>(quotes))
            case let .failure(error):
                core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
}
