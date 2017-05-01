//
//  UsernameViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import TextFieldEffects

class UsernameViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate let checkImage = UIImage(named: "check")
    fileprivate let xImage = UIImage(named: "x")
    fileprivate let disabledColor = UIColor.flatGray.withAlphaComponent(0.6)
    fileprivate let enabledColor = UIColor.flatGrayDark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let avatarVC = AvatarViewController.initializeFromStoryboard()
        navigationController?.pushViewController(avatarVC, animated: true)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func update(with state: AppState) {
        if let text = textField.text {
            imageView.image = state.newUserState.usernameIsAvailable ? checkImage : xImage
            imageView.tintColor = state.newUserState.usernameIsAvailable ? UIColor.flatLime : .flatRed
            
            if text.isEmpty || textField.isFirstResponder {
                imageView.image = nil
            }
        }
        nextButton.isEnabled = state.newUserState.username != nil && state.newUserState.usernameIsAvailable
        nextButton.backgroundColor = nextButton.isEnabled ? enabledColor : disabledColor
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateNextButton()
    }
    
    
    func updateNextButton(verify: Bool = false) {
        core.fire(event: UsernameAvailabilityUpdated(isAvailable: false))
        
        if let username = textField.text, verify {
            core.fire(command: CheckUsernameAvailability(username: username.lowercased()))
        }
    }
    
}


extension UsernameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let illegalCharacterSet = CharacterSet(charactersIn: " @#%^&*(){}[]:;\"'<>,?!/`~+=")
        if let _ = string.rangeOfCharacter(from: illegalCharacterSet) {
            return false
        } else if let _ = string.rangeOfCharacter(from: CharacterSet.uppercaseLetters) {
            textField.text? += string.lowercased()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateNextButton(verify: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
