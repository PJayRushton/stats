//
//  AddTeamViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import Marshal
import Presentr

class AddTeamViewController: Component, AutoStoryboardInitializable {
    
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var videoHolderView: UIView!
    @IBOutlet weak var codeHolderView: UIView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var qrCodeFrameView: UIView?
    
    fileprivate let supportedBarCodes = [AVMetadataObjectTypeQRCode]
    fileprivate let networkAccess = FirebaseNetworkAccess()
    
    fileprivate var allTextFields: [UITextField] {
        return [textField1, textField2, textField3, textField4, textField5]
    }
    fileprivate var keyboardIsUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        setUpQRFramer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.flatLime
        captureSession?.startRunning()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setUpCaptureSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = videoHolderView.frame
            view.layer.addSublayer(videoPreviewLayer!)
        } catch {
            print(error)
            return
        }
    }
    
    fileprivate func setUpQRFramer() {
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.flatLime.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

}


// MARK: - Fileprivate 

extension AddTeamViewController {
    
    fileprivate func searchForTeam(with metadata: String) {
        var teamId = metadata
        var ownershipType = TeamOwnershipType.fan
        let parts = metadata.components(separatedBy: " ")
        guard parts.count == 2 else { return }
        teamId = parts.first!
        guard let typeString = parts.last, let type = TeamOwnershipType(rawValue: typeString) else { return }
        ownershipType = type
        
        let ref = StatsRefs.teamsRef.child(teamId)
        networkAccess.getData(at: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                DispatchQueue.main.async {
                    self.presentConfirmationAlert(withTeam: team, ownershipType: ownershipType)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.presentErrorAlert()
                }
                self.core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    fileprivate func searchForTeam(withCode code: String, ownershipType: TeamOwnershipType) {
        let query = StatsRefs.teamsRef.queryOrdered(byChild: shareCodeKey).queryEqual(toValue: code)
        networkAccess.getData(withQuery: query) { result in
            let teamResult = result.map { (json: JSONObject) -> Team in
                guard let key = json.keys.first else { throw MarshalError.nullValue(key: "team")}
                let teamJSON: JSONObject = try json.value(for: key)
                return try Team(object: teamJSON)
            }
            switch teamResult {
            case let .success(team):
                DispatchQueue.main.async {
                    self.presentConfirmationAlert(withTeam: team, ownershipType: ownershipType)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.presentErrorAlert()
                }
                self.core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    fileprivate func presentConfirmationAlert(withTeam team: Team, ownershipType: TeamOwnershipType) {
        let title = team.name
        let alert = Presentr.alertViewController(title: title, body: "Did I find the team you were looking for?")
        alert.addAction(AlertAction(title: "No 😞", style: .cancel, handler:  { _ in
            self.captureSession?.startRunning()
            DispatchQueue.main.async {
                self.clearTextFields()
            }
        }))
        
        alert.addAction(AlertAction(title: "Nailed it! 😎", style: .default, handler: { _ in
            self.core.fire(command: AddTeamToUser(team: team, type: ownershipType))
            self.core.fire(command: SubscribeToTeam(withId: team.id))
            self.dismiss(animated: true, completion: { 
                self.dismiss(animated: true, completion: nil)
            })
        }))
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    fileprivate func presentErrorAlert(withMessage message: String? = nil) {
        let defaultMessage = "Hmm... This is awkward... 😅"
        let alert = Presentr.alertViewController(title: message ?? defaultMessage, body: "Something went wrong")
        alert.addAction(AlertAction(title: "Let's try again", style: .cancel, handler:  { _ in
            self.captureSession?.startRunning()
            DispatchQueue.main.async {
                self.clearTextFields()
            }
        }))
        
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }

}

extension AddTeamViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let objects = metadataObjects, objects.isEmpty == false else {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, supportedBarCodes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let metadataString = metadataObj.stringValue {
                searchForTeam(with: metadataString)
                captureSession?.stopRunning()
            }
        }
    }
    
    func moveView(up: Bool = true) {
        if up && keyboardIsUp || !up && !keyboardIsUp { return }
        UIView.animate(withDuration: 0.25) {
            let amount: CGFloat = up ? -150.0 : 150.0
            self.view.frame.origin.y += amount
            self.keyboardIsUp = up
        }
    }
    
}

extension AddTeamViewController: UITextFieldDelegate {
    
    func clearTextFields() {
        var wasTyping = false
        allTextFields.forEach { tf in
            if let text = tf.text, !text.isEmpty {
                wasTyping = true
            }
            tf.text = ""
            
        }
        
        if wasTyping {
            textField1.becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 1

    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let text = sender.text, text.characters.count == 1 {
            _ = textFieldShouldReturn(sender)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField1 {
            textField2.becomeFirstResponder()
        } else if textField == textField2 {
            textField3.becomeFirstResponder()
        } else if textField == textField3 {
            textField4.becomeFirstResponder()
        } else if textField == textField4 {
            textField5.becomeFirstResponder()
        } else {
            var strings = allTextFields.flatMap( { $0.text })
            guard strings.count == 5 else { presentErrorAlert(); return true }
            guard case let ownershipString = strings.removeLast(), let ownershipInt = Int(ownershipString) else { presentErrorAlert(); return true }
            let ownershipType = TeamOwnershipType(hashValue: ownershipInt)
            searchForTeam(withCode: strings.joined(), ownershipType: ownershipType)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveView(up: false)
    }
    
}
