//
//  TextEditViewController.swift
//  Stats
//
//  Created by Parker Rushton on 5/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Presentr
import TextFieldEffects

class TextEditViewController: Component, AutoStoryboardInitializable {
    
    // MARK: - Static
    
    static let presenter: Presentr = {
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.8), height: .custom(size: 300), center: .center))
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: HoshiTextField!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var keyboardSaveButton: CustomButton!
    
    
    // MARK: - Public properties
    
    var topLabelText = ""
    var editingText: String?
    var placeholder: String?
    var saveButtonTitle = NSLocalizedString("Save", comment: "")
    var savePressed: ((String) -> Void) = { _ in }
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLabel.text = topLabelText
        textField.text = editingText
        textField.placeholder = placeholder
        textField.inputAccessoryView = keyboardView
        saveButton.setTitle(saveButtonTitle, for: .normal)
        saveButton.isEnabled = false
        keyboardSaveButton.setTitle(saveButtonTitle, for: .normal)
        keyboardSaveButton.isEnabled = false
    }

    
    // MARK: - IBActions

    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let isSavable = !text.isEmpty && text != editingText
        saveButton.isEnabled = isSavable
        keyboardSaveButton.isEnabled = isSavable
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let text = textField.text else { return }
        savePressed(text)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
}

extension TextEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
