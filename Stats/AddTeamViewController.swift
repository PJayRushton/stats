//
//  AddTeamViewController.swift
//  Stats
//
//  Created by Parker Rushton on 3/30/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import AVFoundation
import Presentr

class AddTeamViewController: Component, AutoStoryboardInitializable {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        setUpQRFramer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let videoFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: view.frame.height / 2))
            videoPreviewLayer?.frame = videoFrame
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
                searchForTeam(withId: metadataString)
                captureSession?.stopRunning()
            }
        }
    }
    
    fileprivate func searchForTeam(withId id: String) {
        var teamId = id
        var ownershipType = TeamOwnershipType.fan
        if id.contains(" ") {
            let parts = id.components(separatedBy: " ")
            guard parts.count == 2 else { return }
            teamId = parts.first!
            guard let typeString = parts.last, let type = TeamOwnershipType(rawValue: typeString) else { return }
            ownershipType = type
        }
        let ref = StatsRefs.teamsRef.child(teamId)
        FirebaseNetworkAccess().getData(at: ref) { result in
            let teamResult = result.map(Team.init)
            switch teamResult {
            case let .success(team):
                DispatchQueue.main.async {
                    self.presentConfirmationAlert(withTeam: team, ownershipType: ownershipType)
                }
            case let .failure(error):
                self.core.fire(event: ErrorEvent(error: error, message: nil))
            }
        }
    }
    
    fileprivate func presentConfirmationAlert(withTeam team: Team, ownershipType: TeamOwnershipType) {
        let title = "Is \(team.name) the team you were looking for? "
        let alert = Presentr.alertViewController(title: title, body: "")
        alert.addAction(AlertAction(title: "No 😞", style: .cancel, handler:  { _ in
            self.captureSession?.startRunning()
        }))
        
        alert.addAction(AlertAction(title: "Nailed it! 😎", style: .default, handler: { _ in
            self.core.fire(command: AddTeamToUser(team: team, type: ownershipType))
            self.core.fire(command: SubscribeToTeam(withId: team.id))
        }))
        customPresentViewController(presenter, viewController: alert, animated: true, completion: nil)
    }
    
}
