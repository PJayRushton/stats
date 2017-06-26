//
//  Platform.swift
//  Stats
//
//  Created by Parker Rushton on 6/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation

struct Platform {
    
    @nonobjc static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
