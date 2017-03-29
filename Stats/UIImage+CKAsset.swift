//
//  UIImage+CKAsset.swift
//  CloudKitDemo
//
//  Created by Marcus Smith on 2/29/16.
//  Copyright © 2016 FrozenFireStudios. All rights reserved.
//

import UIKit
import CloudKit

enum ImageFileType {
    case jpg(compressionQuality: CGFloat)
    case png
    
    var fileExtension: String {
        switch self {
        case .jpg(_):
            return ".jpg"
        case .png:
            return ".png"
        }
    }
}

enum ImageError: Error {
    case unableToConvertImageToData
}

extension CKAsset {
    
    convenience init(image: UIImage?, fileType: ImageFileType = .jpg(compressionQuality: 70)) throws {
        guard let image = image else { throw CloudKitError.keyNotFound(key: "image") }
        let url = try image.saveToTempLocationWithFileType(fileType: fileType)
        self.init(fileURL: url as URL)
    }

}

extension UIImage {
    
    func saveToTempLocationWithFileType(fileType: ImageFileType) throws -> URL {
        let imageData: Data?
        
        switch fileType {
        case .jpg(let quality):
            imageData = UIImageJPEGRepresentation(self, quality)
        case .png:
            imageData = UIImagePNGRepresentation(self)
        }
        guard let data = imageData else {
            throw ImageError.unableToConvertImageToData
        }
        
        let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
        let url = URL.init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        try data.write(to: url)
        
        return url
    }
    
}
