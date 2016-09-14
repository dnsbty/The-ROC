//
//  HomeViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/24/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class HomeViewController : UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadCode()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let code = NSUserDefaults.standardUserDefaults().objectForKey("code") as? String
        
        if code == nil && NSUserDefaults.standardUserDefaults().objectForKey("scanLater") as? Bool != true {
            self.performSegueWithIdentifier("scanCode", sender: self)
            return
        }
    }
    
    @IBAction func scanCode(sender: AnyObject) {
        self.performSegueWithIdentifier("scanCode", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scanCode" {
            if let destVC = segue.destinationViewController as? ScannerViewController {
                destVC.parentVC = self
            }
        }
    }
    
    func reloadCode() {
        if let code = NSUserDefaults.standardUserDefaults().objectForKey("code") as? String {
            codeLabel.text = code
            codeImage.image = RSCode39Generator().generateCode(code, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code)
        }
    }
}
