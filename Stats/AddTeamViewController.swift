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
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet var keyboardView: UIView!
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var qrCodeFrameView: UIView?
    
    fileprivate let supportedBarCodes = [AVMetadataObject.ObjectType]()
    fileprivate let networkAccess = FirebaseNetworkAccess()
    
    fileprivate var allTextFields: [UITextField] {
        return [textField1, textField2, textField3, textField4, textField5]
    }
    fileprivate var keyboardIsUp = false
    fileprivate var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        setUpQRFramer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession?.startRunning()
        navigationController?.navigationBar.barTintColor = UIColor.mainAppColor
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
    }
    
}


// MARK: - Fileprivate

extension AddTeamViewController {
    
    fileprivate func setUpCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            guard let captureSession = captureSession else { return }
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            view.bringSubview(toFront: topStack)
        } catch {
            print(error)
            return
        }
    }
    
    fileprivate func setUpQRFramer() {
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.mainAppColor.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    fileprivate func searchForTeam(withCode code: String) {
        guard let processedCode = processedCode(code) else { presentErrorAlert(); return }
        
        isSearching = true
        let query = StatsRefs.teamsRef.queryOrdered(byChild: shareCodeKey).queryEqual(toValue: processedCode.code)
        networkAccess.getData(withQuery: query) { result in
            let teamResult = result.map { (json: JSONObject) -> Team in
                guard let key = json.keys.first else { throw MarshalError.nullValue(key: "team")}
                let teamJSON: JSONObject = try json.value(for: key)
                return try Team(object: teamJSON)
            }
            DispatchQueue.main.async {
                switch teamResult {
                case let .success(team):
                    self.presentConfirmationAlert(withTeam: team, ownershipType: processedCode.type)
                case let .failure(error):
                    self.presentErrorAlert()
                    self.core.fire(event: ErrorEvent(error: error, message: nil))
                }
            }
        }
    }

    fileprivate func processedCode(_ code: String) -> (code: String, type: TeamOwnershipType)? {
        var updatedCode = code
        guard updatedCode.count == 5 else { return nil }
        let lastChar = updatedCode.remove(at: updatedCode.index(before: updatedCode.endIndex))
        guard case let lastNumber = String(lastChar), let ownershipInt = Int(lastNumber) else { return nil }
        let ownershipType = TeamOwnershipType(hashValue: ownershipInt)
        
        return (updatedCode, ownershipType)
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
            self.core.fire(event: Selected<Team>(team))
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }))
        isSearching = false
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
        isSearching = false
        customPresentViewController(alertPresenter, viewController: alert, animated: true, completion: nil)
    }
    
}

extension AddTeamViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let objects = metadataObjects, !objects.isEmpty else {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, supportedBarCodes.contains(metadataObject.type) {
            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) {
                qrCodeFrameView?.frame = barCodeObject.bounds
            }
            
            if let metadataString = metadataObject.stringValue, !isSearching {
                searchForTeam(withCode: metadataString)
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
        let newLength = text.count + string.count - range.length
        return newLength <= 1
        
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let text = sender.text, text.count == 1 {
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
            let shareCode = allTextFields.compactMap( { $0.text?.uppercased() }).joined()
            searchForTeam(withCode: shareCode)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveView(up: false)
    }
    
}
