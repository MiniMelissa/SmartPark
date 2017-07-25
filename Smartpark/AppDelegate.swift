//
//  AppDelegate.swift
//  termination_project
//
//  Created by Timothy Redband on 2/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let reach = Reachability()!
    var continue_upload: Bool = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        SmartMotionSensorsManager.motion_sensors_instance.startSmartMotionSensorsManager()
        SmartGPSManager.gps_instance.startGPSManagerUpdates()
        SmartMotionStateManager.motionstate_instance.startSmartMotionStateManager()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            if user.hostedDomain != "binghamton.edu" {
                GIDSignIn.sharedInstance().signOut()
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                    object: nil,
                    userInfo: ["statusText": "Domain must be @binghamton.edu"])
            } else {
            // [START_EXCLUDE]
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                    object: nil,
                    userInfo: ["statusText": "Signed in user:\n\(fullName)"])
                // [END_EXCLUDE]
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.continue_upload = false
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.continue_upload = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        /*
        DispatchQueue.global(qos: .background).async {
            // Background Thread
            while (self.reach.isReachableViaWiFi && self.continue_upload){
                print("Wifi = \(self.reach.isReachableViaWiFi)")
                if DEBUGPOST {print("In while loop")}
                if DEBUGPOST {print("accel lock")}
                accel_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("Accel execute")}
                let accel_data = LocalDB.db_instance.accel_rows_to_json()
                LocalDB.db_instance.post_data(post_data: accel_data, url_p: ACCELEROMETER_URL, url_type: URL_TYPE.ACCEL)
                
                if DEBUGPOST {print("gyro lock")}
                gyro_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("gyro execute")}
                let gyro_data = LocalDB.db_instance.gyro_rows_to_json()
                LocalDB.db_instance.post_data(post_data: gyro_data, url_p: GYROSCOPE_URL, url_type: URL_TYPE.GYRO)
                
                if DEBUGPOST {print("battery lock")}
                battery_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("battery execuet")}
                let battery_data = LocalDB.db_instance.battery_rows_to_json()
                LocalDB.db_instance.post_data(post_data: battery_data, url_p: BATTERY_URL, url_type: URL_TYPE.BATTERY)
                
                if DEBUGPOST {print("wifi lock")}
                wifi_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("wifi execute")}
                let wifi_data = LocalDB.db_instance.wifi_rows_to_json()
                LocalDB.db_instance.post_data(post_data: wifi_data, url_p: WIFI_URL, url_type: URL_TYPE.WIFI)
                
                if DEBUGPOST {print("motionstate lock")}
                motionstate_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("motionstate execute")}
                let motionstate_data = LocalDB.db_instance.motionState_rows_to_json()
                LocalDB.db_instance.post_data(post_data: motionstate_data, url_p: MOTIONSTATE_URL, url_type: URL_TYPE.MOTIONSTATE)
                
                if DEBUGPOST {print("gps lock")}
                gps_sem.wait(timeout: SEM_WAIT_INTERVAL)
                if DEBUGPOST {print("gps execute")}
                let gps_data = LocalDB.db_instance.gps_rows_to_json()
                LocalDB.db_instance.post_data(post_data: gps_data, url_p: GPS_URL, url_type: URL_TYPE.GPS)
            }
        }
 */

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

