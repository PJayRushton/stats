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
    
    @IBOutlet weak var topSpacerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var doneButton: CustomButton!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var keyboardSubmitButton: CustomButton!

    fileprivate let disabledColor = UIColor.flatGray.withAlphaComponent(0.5)
    fileprivate let enabledColor = UIColor.secondaryAppColor
    
    fileprivate var formIsComplete: Bool {
        guard let _ = core.state.newUserState.email, core.state.newUserState.emailIsAvailable else { return false }
        return emailTextField.text != nil && emailTextField.text!.isValidEmail
    }
    fileprivate var isLoading = false {
        didSet {
            doneButton.isLoading = isLoading
            keyboardSubmitButton.isLoading = isLoading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(respondToKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(respondToKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        navigationController?.setNavigationBarHidden(true, animated: true)
        doneButton.layer.cornerRadius = 5
        emailTextField.inputAccessoryView = keyboardView
    }
    
    
    // MARK: - IBActions
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        checkEmailAvailability()
        updateEmail()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        saveAndClose()
    }
    
    
    // MARK: - Update with State
    
    override func update(with state: AppState) {
        isLoading = false
        updateDoneButton()
        updateEmail()
    }

}


// MARK: - Fileprivate 

extension NewUserViewController {
    
    func respondToKeyboard(_ notification: NSNotification) {
        var isHidden: Bool
        if notification.name == .UIKeyboardWillShow {
            isHidden = true
        } else {
            isHidden = false
        }
        UIView.animate(withDuration: 0.25) {
            self.topSpacerView.isHidden = isHidden
        }
    }
    
    fileprivate func updateEmail() {
        emailErrorLabel.text = ""
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
            return
        } else if !email.isValidEmail || core.state.newUserState.email == nil || !core.state.newUserState.email!.isValidEmail {
            emailErrorLabel.text = "Invalid Email"
        } else if !core.state.newUserState.emailIsAvailable {
            emailErrorLabel.text = "Already taken"
        } else {
            core.fire(event: EmailUpdated(email: email))
        }
    }
    
    fileprivate func checkEmailAvailability() {
        guard let email = emailTextField.text, email.isValidEmail else { core.fire(event: NoOp()); return }
        isLoading = true
        core.fire(command: CheckEmailAvailability(email: email.lowercased()))
    }
    
    fileprivate func updateDoneButton() {
        doneButton.isEnabled = formIsComplete
        keyboardSubmitButton.isEnabled = formIsComplete
    }
    
    fileprivate func saveAndClose() {
        isLoading = true
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
    
    fileprivate func presentErrorAlert(withMessage message: String? = nil) {
        let defaultMessage = "Hmm... This is awkward... 😅"
        let alert = Presentr.alertViewController(title: message ?? defaultMessage, body: "Something went wrong")
        alert.addAction(AlertAction(title: "Let's try again", style: .cancel, handler: nil))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}


extension NewUserViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = string.rangeOfCharacter(from: CharacterSet.uppercaseLetters) {
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
