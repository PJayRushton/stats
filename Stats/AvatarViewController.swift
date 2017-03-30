//
//  AvatarViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class AvatarViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        if let imagePicker = imagePicker(withSourceType: .camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            // TODO:
        }
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        if let imagePicker = imagePicker(withSourceType: .photoLibrary) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            // TODO:
        }
    }
    
    @IBAction func stockButtonPressed(_ sender: UIButton) {
        let stockVC = StockPhotosViewController.initializeFromStoryboard()
        navigationController?.pushViewController(stockVC, animated: true)
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let emailVC = EmailViewController.initializeFromStoryboard()
        navigationController?.pushViewController(emailVC, animated: true)
    }
    
    override func update(with state: AppState) {
        selectedImage = state.newUserState.avatar
    }
    
}


// MARK: - UIImagePickerControllerDelegate

extension AvatarViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        core.fire(event: Selected<UIImage>(selectedImage))
    }
    
}
