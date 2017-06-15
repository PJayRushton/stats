//
//  PlayerCreationViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AIFlatSwitch
import BetterSegmentedControl
import ContactsUI
import Firebase
import Presentr
import TextFieldEffects

class PlayerCreationViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var jerseyNumberTextField: HoshiTextField!
    @IBOutlet weak var phoneTextField: HoshiTextField!
    @IBOutlet weak var genderSegControl: BetterSegmentedControl!
    @IBOutlet weak var subSwitch: AIFlatSwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveAddButton: CustomButton!
    
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var keyboardNextButton: UIButton!
    @IBOutlet weak var keyboardPreviousButton: UIButton!
    @IBOutlet weak var keyboardSaveButton: UIButton!
    @IBOutlet weak var keyboardSaveAddButton: UIButton!
    @IBOutlet weak var keyboardSpacerView: UIView!
    @IBOutlet var saveButtonsWidthConstraint: NSLayoutConstraint!
    
    var editingPlayer: Player?
    
    fileprivate var contactHelper: ContactsHelper!
    fileprivate lazy var newPlayerRef: DatabaseReference = {
        return StatsRefs.playersRef(teamId: App.core.state.teamState.currentTeam!.id).childByAutoId()
    }()
    fileprivate var saveButtons: [UIButton] {
        return [saveButton, saveAddButton, keyboardSaveButton, keyboardSaveAddButton]
    }

    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactHelper = ContactsHelper(viewController: self)
        contactHelper.contactSelected = contactSelected
        deleteButton.isHidden = true
        
        setUpSegControl()
        if let editingPlayer = editingPlayer {
            updateUI(with: editingPlayer)
        }
        nameTextField.inputAccessoryView = keyboardView
        jerseyNumberTextField.inputAccessoryView = keyboardView
        phoneTextField.inputAccessoryView = keyboardView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if editingPlayer == nil {
            nameTextField.becomeFirstResponder()
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func addressBookPressed(_ sender: UIButton) {
        contactHelper.addressButtonPressed()
    }
    
    @IBAction func genderChanged(_ sender: BetterSegmentedControl) {
        updateSaveButtons()
    }
    
    @IBAction func subSwitchChanged(_ sender: Any) {
        updateSaveButtons()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let newPlayer = constructedPlayer() else { return }
        savePlayer(newPlayer, add: false)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        showDeleteConfirmation()
    }
    
    @IBAction func saveAndAddButtonPressed(_ sender: UIButton) {
        guard let newPlayer = constructedPlayer() else { return }
        savePlayer(newPlayer, add: true)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButtons()
    }
    
    @IBAction func subLabelTapped(_ sender: UITapGestureRecognizer) {
        subSwitch.setSelected(!subSwitch.isSelected, animated: true)
        updateSaveButtons()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        moveFirstResponder(next: true)
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        moveFirstResponder(next: false)
    }
    
    @IBAction func dismissKeyboardButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    // MARK: - Subscriber 
    
    override func update(with state: AppState) {
        updateSaveButtons()
    }
    
}


// MARK: - Fileprivate 

extension PlayerCreationViewController {
    
    fileprivate func updateUI(with player: Player) {
        topLabel.text = "Edit Player"
        nameTextField.text = player.name
        jerseyNumberTextField.text = player.jerseyNumber
        phoneTextField.text = player.phone
        try? genderSegControl.setIndex(UInt(player.gender.rawValue), animated: false)
        subSwitch.isSelected = player.isSub
        saveAddButton.isHidden = true
        deleteButton.isHidden = false
        updateSaveButtons()
    }
    
    fileprivate func setUpSegControl() {
        genderSegControl.titles = Gender.allValues.map { $0.stringValue }
        let font = FontType.lemonMilk.font(withSize: 13)
        genderSegControl.titleFont = font
        genderSegControl.selectedTitleFont = font
        genderSegControl.titleColor = .gray400
        genderSegControl.indicatorViewBackgroundColor = .secondaryAppColor
        genderSegControl.cornerRadius = 5
    }
    
    fileprivate func updateSaveButtons() {
        let newPlayer = constructedPlayer()
        var isSavable = newPlayer != nil
        
        if let editingPlayer = editingPlayer {
            isSavable = newPlayer != nil && !newPlayer!.isSame(as: editingPlayer)
        }
        saveButton.isEnabled = isSavable
        saveAddButton.isEnabled = isSavable
        
        keyboardSaveButton.isHidden = !isSavable
        keyboardSaveAddButton.isHidden = !isSavable || editingPlayer != nil
        keyboardSpacerView.isHidden = isSavable
        saveButtonsWidthConstraint.isActive = !keyboardSaveButton.isHidden && !keyboardSaveAddButton.isHidden
    }
    
    fileprivate func constructedPlayer(add: Bool = false) -> Player? {
        guard let team = core.state.teamState.currentTeam else { return nil }
        guard let name = nameTextField.text, !name.isEmpty else { return nil }
        let jerseyNumber = jerseyNumberTextField.text!.isEmpty ? nil : jerseyNumberTextField.text
        guard let gender = Gender(rawValue: Int(genderSegControl.index)) else { return nil }
        let id = StatsRefs.playersRef(teamId: team.id).childByAutoId().key
        
        var phone: String?
        if let phoneText = phoneTextField.text, !phoneText.isEmpty {
            guard phoneText.isValidPhoneNumber else { return nil }
            phone = phoneText
        }
        if var editingPlayer = editingPlayer {
            editingPlayer.name = name
            editingPlayer.jerseyNumber = jerseyNumber
            editingPlayer.phone = phone
            editingPlayer.gender = gender
            editingPlayer.isSub = subSwitch.isSelected
            return editingPlayer
        } else {
            return Player(id: id, name: name, jerseyNumber: jerseyNumber, isSub: subSwitch.isSelected, phone: phone, gender: gender, teamId: team.id)
        }
    }
    
    fileprivate func savePlayer(_ player: Player, add: Bool) {
        if let _ = editingPlayer {
            core.fire(command: UpdateObject(player))
            dismiss(animated: true, completion: nil)
        } else {
            core.fire(command: CreatePlayer(player))
            
            if add {
                clear()
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func clear() {
        nameTextField.text = ""
        jerseyNumberTextField.text = ""
        phoneTextField.text = ""
        subSwitch.setSelected(false, animated: true)
        updateSaveButtons()
        nameTextField.becomeFirstResponder()
    }
    
    fileprivate func moveFirstResponder(next: Bool) {
        if (nameTextField.isFirstResponder && !next) || (phoneTextField.isFirstResponder && next) {
            view.endEditing(false)
        } else if (nameTextField.isFirstResponder && next) || (phoneTextField.isFirstResponder && !next) {
                jerseyNumberTextField.becomeFirstResponder()
        } else if jerseyNumberTextField.isFirstResponder {
            let nextTextField = next ? phoneTextField : nameTextField
            nextTextField?.becomeFirstResponder()
        }
    }
    
    fileprivate func showDeleteConfirmation() {
        guard let editingPlayer = editingPlayer else { return }
        let alert = Presentr.alertViewController(title: "Delete \(editingPlayer.name)?", body: "This cannot be undone")
        alert.addAction(AlertAction(title: "Cancel 😳", style: .cancel, handler: nil))
        alert.addAction(AlertAction(title: "☠️", style: .destructive, handler: {
            self.core.fire(command: DeleteObject(object: editingPlayer))
            self.dismiss(animated: true, completion: { 
                self.dismiss(animated: true, completion: nil)
            })
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}


// MARK: - Contacts

extension PlayerCreationViewController {

    func contactSelected(result: Result<(String, String)>) {
        switch result {
        case let .success(name, phone):
            if let nameText = nameTextField.text, nameText.isEmpty {
                nameTextField.text = name
            }
            phoneTextField.text = phone
        case let .failure(error):
            contactHelper.presentErrorAlert()
            dump(error)
        }
    }

    
}

extension PlayerCreationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            jerseyNumberTextField.becomeFirstResponder()
        } else if textField == jerseyNumberTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            view.endEditing(true)
        }
        return true
    }
    
}
