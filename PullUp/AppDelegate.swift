//
//  AppDelegate.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var ref: DatabaseReference!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        ref = Database.database().reference()

        Auth.auth().signInAnonymously { authResult, error in
//            print("signed in. UID: \(authResult?.user.uid)")
//            print("ERROR \(error)")
        }
        let navBarColor = UIColor("881c1c")

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = navBarColor

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = barAppearance
        navigationBar.scrollEdgeAppearance = barAppearance // for scrollable content or large titles
        print("ran launching func")
        
        
//        let masterViewController = NavigationController(rootViewController: LaunchViewController())
//        let detailViewController = NavigationController()
//        let splitViewController = UISplitViewController()
//        splitViewController.viewControllers = [masterViewController, detailViewController]
//        splitViewController.preferredDisplayMode = .allVisible
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = splitViewController
//        window?.makeKeyAndVisible()
        
        if UserDefaults.isFirstLaunch() {
            // Enable Text Messages
            UserDefaults.standard.set(true, forKey: "Text Messages")
        }
        return true
    }

}

