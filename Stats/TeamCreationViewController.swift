//
//  TeamCreationViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import Kingfisher
import Firebase
import TextFieldEffects

class TeamCreationViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var nameTextField: MadokaTextField!
    @IBOutlet weak var seasonTextField: MadokaTextField!
    @IBOutlet weak var sportSegControl: BetterSegmentedControl!
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var stockPhotoButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    var isDismissable = true
    var editingTeam: Team?
    
    fileprivate lazy var newRefs: (teamRef: FIRDatabaseReference, seasonRef: FIRDatabaseReference) = {
        let teamRef = StatsRefs.teamsRef.childByAutoId()
        let seasonRef = StatsRefs.seasonsRef(teamId: teamRef.key).childByAutoId()
        return (teamRef, seasonRef)
    }()
    
    fileprivate var selectedSport: TeamSport {
        return TeamSport(rawValue: Int(sportSegControl.index)) ?? .slowPitch
    }
    
    fileprivate var currentImageURL: URL? {
        didSet {
            imageView.kf.setImage(with: currentImageURL)
            trashButton.isHidden = currentImageURL == nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpColors()
        setUpSegControl()
        imageView.layer.cornerRadius = 5

        
        if !isDismissable {
            navigationItem.leftBarButtonItem = nil
        }
        if let editingTeam = editingTeam {
            updateUI(with: editingTeam)
            core.fire(event: Selected<URL>(editingTeam.imageURL))
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segControlChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if currentImageURL == nil {
            cameraButtonPressed(cameraButton)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let picker = standardImagePickerAlert()
        present(picker, animated: true, completion: nil)
    }

    @IBAction func stockButtonPressed(_ sender: UIButton) {
    }

    @IBAction func trashButtonPressed(_ sender: UIButton) {
        core.fire(event: Selected<URL>(nil))
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveTeam()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        updateSaveButton()
    }

    
    // MARK: - Subscriber
    
    override func update(with state: AppState) {
        currentImageURL = state.newTeamState.imageURL
        updateSaveButton()
        loadingImageView.isHidden = !state.newTeamState.isLoading
        
        if !loadingImageView.isHidden {
            loadingImageView.rotate()
        }
    }
    
}

extension TeamCreationViewController {
    
    fileprivate func setUpColors() {
        navigationController?.navigationBar.barTintColor = .secondaryAppColor
        nameTextField.borderColor = .mainAppColor
        nameTextField.layer.cornerRadius = 5
        seasonTextField.borderColor = .mainAppColor
        saveButton.backgroundColor = .mainAppColor
        saveButton.layer.cornerRadius = 5
    }
    
    fileprivate func setUpSegControl() {
        sportSegControl.titles = TeamSport.allValues.map { $0.stringValue }
        sportSegControl.titleFont = FontType.lemonMilk.font(withSize: 14)
        sportSegControl.selectedTitleFont = FontType.lemonMilk.font(withSize: 16)
        sportSegControl.titleColor = .gray400
        sportSegControl.indicatorViewBackgroundColor = .secondaryAppColor
    }
    
    fileprivate func saveSeason() {
        guard let seasonName = seasonTextField.text else { return }
        let newSeason = Season(id: newRefs.seasonRef.key, name: seasonName, teamId: newRefs.teamRef.key)
        core.fire(command: UpdateObject(object: newSeason))
    }
    
    fileprivate func updateUI(with team: Team) {
        nameTextField.text = team.name
        seasonTextField.isHidden = true
        try? sportSegControl.setIndex(UInt(team.sport.rawValue), animated:  true)
        imageView.kf.setImage(with: team.imageURL)
    }
    
    fileprivate func updateSaveButton() {
        let isConstructable = constructedTeam() != nil
        saveButton.isEnabled = isConstructable
        
        if let editingTeam = editingTeam {
            let isSame = nameTextField.text! == editingTeam.name &&
                selectedSport == editingTeam.sport &&
                core.state.newTeamState.imageURL == editingTeam.imageURL
            
            saveButton.isEnabled = isConstructable && !isSame
        }
        saveButton.backgroundColor = saveButton.isEnabled ? UIColor.mainAppColor : UIColor.mainAppColor.withAlphaComponent(0.5)
    }
    
    fileprivate func constructedTeam() -> Team? {
        guard let name = nameTextField.text else { return nil }
        let newTeamState = core.state.newTeamState
        
        if var editingTeam = editingTeam {
            editingTeam.name = name
            editingTeam.sport = selectedSport
            editingTeam.imageURLString = core.state.newTeamState.imageURL?.absoluteString
            
            return editingTeam
        }
        guard let imageURL = newTeamState.imageURL else { return nil }
    
        return Team(id: newRefs.teamRef.key, currentSeasonId: newRefs.seasonRef.key, imageURLString: imageURL.absoluteString, name: name, sport: selectedSport)
    }
    
    fileprivate func saveTeam() {
        guard let newTeam = constructedTeam() else { return }
        core.fire(command: SaveTeam(team: newTeam))
        
        if editingTeam == nil {
            saveSeason()
        }
        if isDismissable {
            dismiss(animated: true, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}

extension TeamCreationViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let imageData = UIImageJPEGRepresentation(image, 0.5) {
            core.fire(command: UploadToStorage(imageData: imageData, objectId: editingTeam?.id ?? newRefs.teamRef.key, type: .team))
            core.fire(event: Selected<URL>(nil))
        } else {
            core.fire(event: ErrorEvent(error: nil, message: NSLocalizedString("Image processing failed. Try again", comment: "")))
        }
    }
    
}


extension TeamCreationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField, editingTeam == nil {
            seasonTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
}
