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
        
        let code = NSUserDefaults.standardUserDefaults().objectForKey("code") as? String
        
        if code == nil {
            self.performSegueWithIdentifier("scanCode", sender: self)
        }
        
        codeLabel.text = code!
        codeImage.image = RSCode39Generator().generateCode(code!, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code)
    }
}
