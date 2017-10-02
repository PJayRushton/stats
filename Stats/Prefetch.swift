//
//  Prefetch.swift
//  Stats
//
//  Created by Parker Rushton on 7/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Kingfisher

struct Prefetch: Command {
    
    var urls: [URL]
    
    init(_ urls: [URL]) {
        self.urls = urls
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        DispatchQueue.main.async {
            let fetcher = ImagePrefetcher(urls: self.urls)
            fetcher.start()
        }
    }
    
}
