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
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var overlayImage: UIImageView!
    
    @IBAction func scanLater(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input device on the captureSession
            captureSession?.addInput(input as AVCaptureInput)
        }
        catch let error as NSError {
            // If any error occurs, simply log the description of it and don't continue any further
            print("\(error.localizedDescription)")
            return
        }
        
        // Initialize an AVCaptureMetadataOutput object and set it as the output device to the capture session
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the callback
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
        
        // Initialize the video preview layer and add it as a sublayer to the view preview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession?.startRunning()
        
        // Bring UI to the front
        view.bringSubviewToFront(overlayImage)
        view.bringSubviewToFront(instructionLabel)
        view.bringSubviewToFront(laterButton)
        
        // Initialize barcode frame to highlight the barcode
        barcodeFrameView = UIView()
        barcodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        barcodeFrameView?.layer.borderWidth = 2
        view.addSubview(barcodeFrameView!)
        view.bringSubviewToFront(barcodeFrameView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeCode39Code {
            captureSession?.stopRunning()
            // If the found metadata is equal to the Code-39 barcode metadata set the bounds
            let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            barcodeFrameView?.frame = barcodeObject.bounds
            
            if metadataObj.stringValue != nil {
                NSUserDefaults.standardUserDefaults().setObject(metadataObj.stringValue, forKey: "code")
                self.performSegueWithIdentifier("doneScanning", sender: self)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}