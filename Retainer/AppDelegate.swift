//
//  AppDelegate.swift
//  Retainer
//
//  Created by NTGMM-02 on 23/10/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        setupPushNotifcation(application)
        FirebaseApp.configure()
        //application.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.4667229652, green: 0.8283264041, blue: 0.323969543, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        if Auth.auth().currentUser?.uid != nil {
            let pageToShow = mainPage()
            let controller = UINavigationController(rootViewController: pageToShow)
            self.window?.rootViewController = controller
        }
        else{
           self.window?.rootViewController = UINavigationController(rootViewController: Welcome())
        }
        return true
    }

   func setupPushNotifcation(_ application: UIApplication){
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (PermissionGranted, error) in
            if PermissionGranted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }else{
                print("User Notification permission denied.\(error?.localizedDescription ?? "error")")
            }
        }
    } else {
        // Fallback on earlier version
    let notificationSetting = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
    application.registerForRemoteNotifications()
    application.registerUserNotificationSettings(notificationSetting)
    }
    
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("successfully register for remote notification with token Id:\(deviceToken)")
        print(tokenString(deviceToken))
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notification:\(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("MessageId:\(String(describing: userInfo["gcm_message_id"]))")
        print(userInfo)
    }
    func tokenString(_ deviceToken:Data)->String{
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
     return tokenParts.joined()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "Retainer")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

