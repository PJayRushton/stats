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
    
    @IBAction func laterButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension AvatarViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
    }
    
}
