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
import Firebase
import TextFieldEffects

class PlayerCreationViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nameTextField: MadokaTextField!
    @IBOutlet weak var jerseyNumberTextField: MadokaTextField!
    @IBOutlet weak var phoneTextField: MadokaTextField!
    @IBOutlet weak var genderSegControl: BetterSegmentedControl!
    @IBOutlet weak var subSwitch: AIFlatSwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveAddButton: UIButton!
    
    fileprivate lazy var newPlayerRef: FIRDatabaseReference = {
        return StatsRefs.playersRef(teamId: App.core.state.teamState.currentTeam!.id).childByAutoId()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegControl()
    }
    
    @IBAction func genderControlChanged(_ sender: BetterSegmentedControl) {
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let newPlayer = constructedPlayer() else { return }
        savePlayer(newPlayer, add: false)
    }
    
    @IBAction func saveAndAddButtonPressed(_ sender: UIButton) {
        guard let newPlayer = constructedPlayer() else { return }
        savePlayer(newPlayer, add: true)
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButtons()
    }
    
    
    // MARK: - Subscriber 
    
    override func update(with state: AppState) {
        updateSaveButtons()
    }
    
}

extension PlayerCreationViewController {
    
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
       let isSavable = constructedPlayer() != nil
        saveButton.isEnabled = isSavable
        saveAddButton.isEnabled = isSavable
    }
    
    fileprivate func constructedPlayer(add: Bool = false) -> Player? {
        guard let team = core.state.teamState.currentTeam else { return nil }
        guard let name = nameTextField.text, !name.isEmpty else { return nil }
        guard let gender = Gender(rawValue: Int(genderSegControl.index)) else { return nil }
        let id = StatsRefs.playersRef(teamId: team.id).childByAutoId().key
        return Player(id: id, name: name, jerseyNumber: jerseyNumberTextField.text, isSub: subSwitch.isSelected, phone: phoneTextField.text, gender: gender, teamId: team.id)
    }
    
    fileprivate func savePlayer(_ player: Player, add: Bool) {
        core.fire(command: CreatePlayer(player))
        
        if add {
            clear()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func clear() {
        nameTextField.text = ""
        jerseyNumberTextField.text = ""
        phoneTextField.text = ""
        subSwitch.setSelected(false, animated: true)
        updateSaveButtons()
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
