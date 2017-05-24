//
//  UploadToStorage.swift
//  Stats
//
//  Created by Parker Rushton on 4/4/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Firebase

enum ImageType {
    case avatar
    case team
}

struct UploadToStorage: Command {
    
    var objectId: String
    var imageData: Data
    var type: ImageType
    
    init(imageData: Data, objectId: String, type: ImageType) {
        self.imageData = imageData
        self.objectId = objectId
        self.type = type
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        var ref: StorageReference
        switch type {
        case .avatar:
            ref = StatsRefs.userAvatarStorageRef(userId: objectId)
        case .team:
            ref = StatsRefs.teamImageStorageRef(teamId: objectId)
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        core.fire(event: Loading<URL>(nil))
        
        networkAccess.uploadData(imageData, toRef: ref, with: metadata) { result in
            switch result {
            case let .success(url):
                core.fire(event: Selected<URL>(url))
            case let .failure(error):
                core.fire(event: Selected<URL>(nil))
                core.fire(event: ErrorEvent(error: error, message: "File upload failed"))
            }
        }
    }
    
}
