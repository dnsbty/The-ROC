//
//  OnboardingViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 9/14/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import UIKit

class OnboardingViewController : UIViewController {
    
    @IBAction func enableNotifications(sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "onboarded")
        self.performSegueWithIdentifier("showMain", sender: self)
    }
    
    @IBAction func enableNotificationsLater(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "onboardingTriedDate")
        self.performSegueWithIdentifier("showMain", sender: self)
    }
}
