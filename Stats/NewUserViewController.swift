//
//  NewUserViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr
import TextFieldEffects

class NewUserViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var doneButton: CustomButton!

    fileprivate let disabledColor = UIColor.flatGray.withAlphaComponent(0.5)
    fileprivate let enabledColor = UIColor.secondaryAppColor
    fileprivate let thumbsUp = "👍"
    fileprivate let redX = "❌"
    fileprivate let glasses = "😎"
    fileprivate var hasTypedUsername = false
    fileprivate var formIsComplete: Bool {
        guard let username = usernameTextField.text, !username.isEmpty else { return false }
        guard let _ = core.state.newUserState.username, core.state.newUserState.usernameIsAvailable else { return false }
        return emailTextField.text == nil || emailTextField.text!.isEmpty || emailTextField.text!.isValidEmail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        doneButton.disabledBackgroundColor = disabledColor
        doneButton.layer.cornerRadius = 5
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender == usernameTextField {
            checkUsernameAvailability()
            hasTypedUsername = true
        } else {
            updateEmail()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let saveCommand = SaveNewUser { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.presentErrorAlert()
                }
            }
        }
        core.fire(command: saveCommand)
    }
    
    override func update(with state: AppState) {
        updateUsernameStuff(state: state)
        updateEmail()
        
        if let _ = state.userState.currentUser, formIsComplete {
            dismiss(animated: true, completion: nil)
        }
    }

}


// MARK: - Fileprivate 

extension NewUserViewController {
    
    fileprivate func updateUsernameStuff(state: AppState) {
        let usernameIsValid = state.newUserState.username != nil && state.newUserState.usernameIsAvailable
        usernameLabel.text = nil
        doneButton.isEnabled = false
        
        guard let username = usernameTextField.text else { usernameErrorLabel.text = nil; return }
        if username.isEmpty {
            usernameErrorLabel.text = hasTypedUsername ? NSLocalizedString("Username can't be empty", comment: "Username text entry is currently empty and can't be to continue") : nil
        } else if username.characters.count < 3 {
            usernameErrorLabel.text = NSLocalizedString("Too short", comment: "Username doesn't have enough characters to be valid")
        } else if username.characters.count > 13 {
            usernameErrorLabel.text = NSLocalizedString("Too long!", comment: "Username has too many characters to be valid")
        } else if !state.newUserState.usernameIsAvailable && !state.newUserState.isLoading {
            usernameErrorLabel.text = NSLocalizedString("😠 Someone beat you to it 😠", comment: "Username is taken by another user")
        } else if usernameIsValid {
            usernameErrorLabel.text = nil
            usernameLabel.text = glasses
            doneButton.isEnabled = true
        }
    }
    
    fileprivate func updateEmail() {
        guard let email = emailTextField.text else { emailLabel.text = nil; return }
        if email.isEmpty {
            emailLabel.text = nil
        } else if !email.isValidEmail {
            emailLabel.text = redX
        } else {
            emailLabel.text = thumbsUp
            core.fire(event: EmailUpdated(email: email))
        }
    }
    
    fileprivate func checkUsernameAvailability(verify: Bool = true) {
        if let username = usernameTextField.text, verify {
            guard username.characters.count > 2  && username.characters.count < 14 else { core.fire(event: NoOp()); return }
            core.fire(command: CheckUsernameAvailability(username: username.lowercased()))
        }
    }
    
    fileprivate func updateDoneButton() {
        doneButton.isEnabled = formIsComplete
    }
    
    fileprivate func presentErrorAlert(withMessage message: String? = nil) {
        let defaultMessage = "Hmm... This is awkward... 😅"
        let alert = Presentr.alertViewController(title: message ?? defaultMessage, body: "Something went wrong")
        alert.addAction(AlertAction(title: "Let's try again", style: .cancel, handler: nil))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}


extension NewUserViewController: UITextFieldDelegate {
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
