//
//  EmailViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class EmailViewController: Component, AutoStoryboardInitializable {

    // MARK: - IBOutlets

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    // MARK: - Properties
    
    fileprivate let checkImage = UIImage(named: "check")
    fileprivate let xImage = UIImage(named: "x")
    fileprivate let disabledColor = UIColor.flatGray.withAlphaComponent(0.6)
    fileprivate let enabledColor = UIColor.flatGrayDark
    
    fileprivate var isReadyToDismiss = true
    fileprivate var isLoading = false {
        didSet {
            spinner.isHidden = !isLoading
        }
    }
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = false
    }
    
    
    // MARK: - IBActions

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        isLoading = true
        core.fire(command: SaveNewUser())
    }
    
    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        updateUI()
        if let _ = state.userState.currentUser, isReadyToDismiss {
            isReadyToDismiss = false
            dismiss(animated: true, completion: nil)
        } else {
            isLoading = false
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        updateUI()
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension EmailViewController {
    
    func updateUI() {
        guard let text = textField.text else { return }
        doneButton.isEnabled = text.isEmpty || (!text.isEmpty && text.isValidEmail)
        imageView.image = doneButton.isEnabled ? checkImage : xImage
        imageView.tintColor = doneButton.isEnabled ? .flatLime : .flatRed
        doneButton.backgroundColor = doneButton.isEnabled ? enabledColor : disabledColor
        
        if text.isEmpty {
            imageView.image = nil
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
