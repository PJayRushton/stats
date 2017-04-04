//
//  CreateTeamViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import Firebase
import TextFieldEffects

class CreateTeamViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var nameTextField: MadokaTextField!
    @IBOutlet weak var seasonTextField: MadokaTextField!
    @IBOutlet weak var sportSegControl: BetterSegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var stockPhotoButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    
    var isDismissable = false
    
    var editingTeam: Team?
    
    fileprivate lazy var newTeamRef: FIRDatabaseReference = {
        return FirebaseNetworkAccess().teamsRef.childByAutoId()
    }()
    
    fileprivate var teamRef: FIRDatabaseReference {
        guard let editingTeam = editingTeam else { return newTeamRef }
        return FirebaseNetworkAccess().teamsRef.child(editingTeam.id)
    }
    
    fileprivate var selectedSport: TeamSport {
        return TeamSport(rawValue: Int(sportSegControl.index)) ?? .slowPitch
    }
    
    fileprivate var currentImage: UIImage? {
        didSet {
            imageView.image = currentImage
            trashButton.isHidden = currentImage == nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isDismissable {
            navigationItem.leftBarButtonItem = nil
        }
        seasonTextField.text = String.seasonSuggestion
        sportSegControl.titles = TeamSport.allValues.map { $0.stringValue }
        sportSegControl.titleFont = FontType.lemonMilk.font(withSize: 14)
        sportSegControl.selectedTitleFont = FontType.lemonMilk.font(withSize: 16)
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        deleteData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let picker = standardImagePickerAlert()
        present(picker, animated: true, completion: nil)
    }

    @IBAction func stockButtonPressed(_ sender: UIButton) {
    }

    @IBAction func trashButtonPressed(_ sender: UIButton) {
        currentImage = nil
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveTeam()
    }
    
}

extension CreateTeamViewController {
    
    fileprivate func updateSaveButton() {
        guard let name = nameTextField.text, !name.isEmpty else { saveButton.isEnabled = false; return  }
        guard let _ = currentImage else { saveButton.isEnabled = false; return }
        guard let seasonText = seasonTextField.text, !seasonText.isEmpty else { saveButton.isEnabled = false; return }
        
        if let editingTeam = editingTeam {
            let isSame = name == editingTeam.name && selectedSport == editingTeam.sport
            saveButton.isEnabled = !isSame
        }
    }
    
    fileprivate func constructedTeam() -> Team {
        if let editingTeam = editingTeam {
        } else {
            guard let name = nameTextField.text else { return nil }
            let newTeamState = core.state.newTeamState
            let season = newTeamState.season
            let imageURL = newTeamState.imageURL
            
            return Team(id: teamRef.key, currentSeasonId: season?.id, imageURLString: imageURL, name: name, sport: selectedSport)
        }
    }
    
    fileprivate func saveTeam() {
        guard let newTeam = constructedTeam() else { return }
        core.fire(command: SaveTeam(team: newTeam))
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func deleteData() {
        if let season
    }
    
}

extension CreateTeamViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let imageData = UIImageJPEGRepresentation(image, 0.5) {
            core.fire(command: UploadToStorage(imageData: imageData, objectId: teamRef.key, type: .team))
        } else {
            core.fire(event: ErrorEvent(error: nil, message: NSLocalizedString("Image processing failed. Try again", comment: "")))
        }
    }
    
}


extension CreateTeamViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            seasonTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
}
