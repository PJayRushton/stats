//
//  AvatarViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class AvatarViewController: Component, AutoStoryboardInitializable {
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let emailVC = EmailViewController.initializeFromStoryboard()
        navigationController?.pushViewController(emailVC, animated: true)
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension AvatarViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
    }
    
}
