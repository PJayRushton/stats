//
//        .........     .........
//      ......  ...........  .....
//      ...        .....       ....
//     ...         ....         ...
//     ...       ........        ...
//     ....      .... ....      ...
//      ...      .... ....      ...
//      .....     .......     ....
//        ...      .....     ....
//         ....             ....
//           ....         ....
//            .....     .....
//              .....  ....
//                .......
//                  ...
//

import UIKit
import Photos

extension UIViewController {
    
    func removeAllChildViewControllers() {
        childViewControllers.forEach { vc in
            vc.removeFromParentViewController()
            vc.view.removeFromSuperview()
        }
    }
    
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePicker(withSourceType type: UIImagePickerControllerSourceType) -> UIViewController? {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization({ _ in })
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            return imageSettingsPermissionAlert()
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = type

        switch type {
        case .camera:
            guard UIImagePickerController.isCameraDeviceAvailable(.rear) else { return nil }
        case .photoLibrary, .savedPhotosAlbum:
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return nil }
        }
        
        return imagePicker
    }
    func standardImagePickerAlert() -> UIViewController {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization({ _ in })
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            return imageSettingsPermissionAlert()
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alert = UIAlertController()
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { action in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    func imageSettingsPermissionAlert() -> UIViewController {
        let alert = UIAlertController(title: "I don't have access to your photos", message: "You'll need enable this in the phone's settings app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Now", style: .default, handler: { action in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        return alert
    }
    
}
