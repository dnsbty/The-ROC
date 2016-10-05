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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let code = UserDefaults.standard.object(forKey: "code") as? String
        
        if code == nil && UserDefaults.standard.object(forKey: "scanLater") as? Bool != true {
            self.performSegue(withIdentifier: "scanCode", sender: self)
            return
        }
    }
    
    @IBAction func scanCode(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "scanCode", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanCode" {
            if let destVC = segue.destination as? ScannerViewController {
                destVC.parentVC = self
            }
        }
    }
    
    func reloadCode() {
        if let code = UserDefaults.standard.object(forKey: "code") as? String {
            codeLabel.text = code
            codeImage.image = RSCode39Generator().generateCode(code, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code)
        }
    }
}
