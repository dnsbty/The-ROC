//
//  OnboardingViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 9/14/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import UIKit

class OnboardingViewController : UIViewController {
    
    @IBAction func enableNotifications(_ sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UserDefaults.standard.set(true, forKey: "onboarded")
        self.performSegue(withIdentifier: "showMain", sender: self)
    }
    
    @IBAction func enableNotificationsLater(_ sender: AnyObject) {
        UserDefaults.standard.set(Date(), forKey: "onboardingTriedDate")
        self.performSegue(withIdentifier: "showMain", sender: self)
    }
}
