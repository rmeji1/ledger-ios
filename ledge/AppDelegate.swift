//
//  AppDelegate.swift
//  ledge
//
//  Created by robert on 12/28/17.
//  Copyright © 2017 com.cre8ivehouse. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import OktaAuth
import Vinculum

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  // Need for orientation
  var orientationLock = UIInterfaceOrientationMask.portrait
  var myOrientation: UIInterfaceOrientationMask = .portrait
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return myOrientation
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //      sleep(1);
    
    guard
      let config = Utils.getPlistConfiguration(),
      let data = try? Vinculum.get("refreshToken")?.value,
      let refreshTokenData = data,
      let refreshToken = String(data: refreshTokenData,
        encoding: String.Encoding.utf8) else{
          
          let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "C8HLoginVCNav") as! UINavigationController
          
          self.window!.rootViewController = homeViewController
          self.window!.makeKeyAndVisible()
          
          return true
    }
    
    _ = OktaAuth.refresh(config, refreshToken: refreshToken).then(in: .main, { refreshToken  in
      OktaAuth.getUser{ response, error in
        if error != nil { print("Error: \(error!)") }
        if response != nil {
          if let profile = response {
            UserDefaults.standard.set(profile["email"], forKey: "email")
            UserDefaults.standard.set(profile["given_name"], forKey: "firstName")
            UserDefaults.standard.set(profile["employeeNumber"], forKey: "id")
            UserDefaults.standard.set(profile["initials"], forKey: "initials")
          }
        }
      }
      DispatchQueue.main.async {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "C8HMainMenuVCNav") as! UINavigationController
        
        self.window!.rootViewController = homeViewController
        self.window!.makeKeyAndVisible()
      }
    }).catch{ error in
      // Prompt for login
      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "C8HLoginVCNav") as! UINavigationController
      
      self.window!.rootViewController = homeViewController
      self.window!.makeKeyAndVisible()
    }
    return true
  }
  
  func showLogin() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil);
    let homeViewController = storyboard.instantiateViewController(withIdentifier: "C8HLoginVCNav") as! UINavigationController
    
    window?.subviews.forEach { $0.removeFromSuperview() }
    window?.rootViewController = nil
    window?.rootViewController = homeViewController
    window?.makeKeyAndVisible()
  }
  
  func restartView() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let homeVC = storyboard.instantiateViewController(withIdentifier: "C8HMainMenuVCNav") as! UINavigationController
    
    window?.subviews.forEach { $0.removeFromSuperview() }
    window?.rootViewController = nil
    window?.rootViewController = homeVC
    window?.makeKeyAndVisible()
  }
  
  func revoke() {
    // Get current accessToken
    guard let accessToken = tokens?.accessToken else { return }
    
    OktaAuth.revoke(accessToken) { response, error in
      if error != nil { debugPrint("Error: \(error!)") }
      if response != nil { debugPrint("AccessToken was revoked") }
    }
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
    //      tokens?.accessToken = OktaAuth.refresh()
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // MARK : - Okta Login
  
  //    func application(_ app: UIApplication,
  //                     open url: URL,
  //                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
  //        return OktaAuth.resume(url, options: options)
  //    }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "ledge")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}

