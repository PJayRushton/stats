//
//  TextEditViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import TextFieldEffects

class TextEditViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: HoshiTextField!
    @IBOutlet weak var saveButton: CustomButton!
    
    var savePressed: ((String) -> Void) = { _ in }
    var topText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLabel.text = topText
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        savePressed(textField.text!)
    }
    
}

extension TextEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
