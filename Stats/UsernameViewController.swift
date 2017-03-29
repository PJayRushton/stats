//
//  UsernameViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/27/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import ChameleonFramework
import TextFieldEffects

class UsernameViewController: UIViewController, AutoStoryboardInitializable {
    
    @IBOutlet weak var textField: MadokaTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate let checkImage = #imageLiteral(resourceName: "check")
    fileprivate let xImage = #imageLiteral(resourceName: "x")
    
    var core = App.core
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

extension UsernameViewController: Subscriber {
    
    func update(with state: AppState) {
        imageView.image = state.newUserState.usernameIsAvailable ? checkImage : xImage
        imageView.tintColor = state.newUserState.usernameIsAvailable ? UIColor.flatLime : .flatRed
        nextButton.isEnabled = state.newUserState.username != nil && state.newUserState.usernameIsAvailable
    }
    
}

extension UsernameViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let username = textField.text, !username.isEmpty else { return }
        core.fire(command: CheckUsernameAvailability(username: username))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
