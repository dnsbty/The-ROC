//
//  AppDelegate.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/24/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // handle notification if opened from a notification
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            handleNotification(notification["aps"] as! [String: AnyObject])
        }
        
        // check to see if the user has already finished onboarding
        if UserDefaults.standard.bool(forKey: "onboarded") {
            
            // if they have, check their notification settings and register them
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
            // send the user to the main storyboard as normal
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        } else {
            // if not check to see if they've been invited in the last seven days
            if let triedDate = UserDefaults.standard.object(forKey: "onboardingTried") as! Date? {
                if triedDate.isGreaterThanDate(Date().addDays(7)) {
                    
                    // if they have go ahead and show them the normal storyboard
                    window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    return true
                }
            }
            
            // otherwise send them through the onboarding process
            window?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // create a string out of the device token
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        // save the device token to user defaults
        UserDefaults.standard.set(tokenString, forKey: "deviceToken")
        
        // send the device token to the server
        Alamofire.request(Router.registerForNotifications(tokenString))
            .responseJSON { response in
                // check if the response was successful
                guard response.result.isSuccess else {
                    print("Error while sending device token: \(response.result.error)")
                    return
                }
                UserDefaults.standard.set(true, forKey: "tokenSent")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        handleNotification(userInfo["aps"] as! [String: AnyObject])
    }
    
    func handleNotification(_ aps : [String: AnyObject]) {
        if let urlString = aps["link_url"] as! String? {
            if let url = URL(string: urlString) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

