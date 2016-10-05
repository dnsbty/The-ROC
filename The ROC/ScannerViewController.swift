//
//  ScannerViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/24/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var barcodeFrameView : UIView?
    var parentVC : HomeViewController?
    var error : NSError? = nil
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var overlayImage: UIImageView!
    
    @IBAction func scanLater(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "scanLater")
        self.parentVC?.reloadCode()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the app has permission to access the device's camera
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied {
            error = NSError(domain: "Camera", code: 1, userInfo: nil)
            return
        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input device on the captureSession
            captureSession?.addInput(input as AVCaptureInput)
        }
        catch let error as NSError {
            // If any error occurs, store it for popup display and don't continue any further
            self.error = error
            return
        }
        
        // Initialize an AVCaptureMetadataOutput object and set it as the output device to the capture session
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the callback
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
        
        // Initialize the video preview layer and add it as a sublayer to the view preview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession?.startRunning()
        
        // Bring UI to the front
        view.bringSubview(toFront: overlayImage)
        view.bringSubview(toFront: instructionLabel)
        view.bringSubview(toFront: laterButton)
        
        // Initialize barcode frame to highlight the barcode
        barcodeFrameView = UIView()
        barcodeFrameView?.layer.borderColor = UIColor.green.cgColor
        barcodeFrameView?.layer.borderWidth = 2
        view.addSubview(barcodeFrameView!)
        view.bringSubview(toFront: barcodeFrameView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if there was an error while loading the view
        if error != nil {
            
            // if there was see if it came from the camera
            if error!.domain == "Camera" {
                
                // if it did create a popup asking the user to give permission to use the camera
                let alert = UIAlertController(
                    title: "Permissions Error",
                    message: "Camera access is required for scanning your ROC pass",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                    (action: UIAlertAction!) in
                    self.scanLater(self)
                }))
                alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                
                // otherwise just use a basic popup
                let alert = UIAlertController(title: error?.localizedDescription, message: error?.localizedRecoverySuggestion, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.scanLater(self)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeCode39Code {
            captureSession?.stopRunning()
            // If the found metadata is equal to the Code-39 barcode metadata set the bounds
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            barcodeFrameView?.frame = barcodeObject.bounds
            
            if metadataObj.stringValue != nil {
                UserDefaults.standard.set(metadataObj.stringValue, forKey: "code")
                self.parentVC?.reloadCode()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
