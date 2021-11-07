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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        FirebaseApp.configure()
        ref = Database.database().reference()

//        var userID: String?
        Auth.auth().signInAnonymously { authResult, error in
//            print (authResult?.user.uid)
//            userID = authResult!.user.uid
//            authResult?.user
            if(error != nil){
//                print("Error: \(error)")
            }
            
        }
        let uid = Auth.auth().currentUser?.uid
//        print("User ID \(Auth.auth().currentUser?.uid)")
//        self.ref.child("users/\(uid!)").setValue(["courses": 1])
        

//        let gameRef0 = thisUsersGamesRef.child("course1").child("game_url")

//        let gameRef1 = thisUsersGamesRef.childByAutoId().child("game_url")
//        gameRef1.setValue("http://www..")
//        self.ref.child("users").child(userID!).setValue(["courses": []])
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

