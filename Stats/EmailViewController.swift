//
//  EmailViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class EmailViewController: Component, AutoStoryboardInitializable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        core.fire(command: SaveNewUser())
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
    
}
