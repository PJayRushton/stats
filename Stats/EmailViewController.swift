//
//  EmailViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class EmailViewController: Component, AutoStoryboardInitializable {
    
    var isReadyToDismiss = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        core.fire(command: SaveNewUser())
    }
    
    override func update(with state: AppState) {
        if let _ = state.userState.currentUser, isReadyToDismiss {
            isReadyToDismiss = false
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension EmailViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let email = textField.text, !email.isEmpty else { return } // FIXME:
        if email.isValidEmail {
            core.fire(event: EmailUpdated(email: email))
        } else {
            // TODO:
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
