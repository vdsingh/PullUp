//
//  AppDelegate.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDynamicLinks
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var ref: DatabaseReference!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        ref = Database.database().reference()
        let navBarColor = UIColor(K.mainColorHex)

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = navBarColor

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = barAppearance
        navigationBar.scrollEdgeAppearance = barAppearance // for scrollable content or large titles
        print("ran launching func")
        
        return true
    }
    
//    func handlePasswordlessSignIn(_ withURL: URL) -> Bool{
//        print("handling passwordless sign in")
////        DynamicLink().ur
//        let link = withURL.absoluteString
//        
//        if Auth.auth().isSignIn(withEmailLink: link){
//            guard let email = UserDefaults.standard.value(forKey: K.emailKey) as? String else {return false}
//            Auth.auth().signIn(withEmail: email, link: link) { (result, error) in
//                if let error = error{
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let result = result else {return}
//                let user = result.user
//                self.ref.child("users").child(user.uid).setValue(["email": email, "timestamp": FieldValue.serverTimestamp()])
//            }
//        }
//        return true
//    }

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        print("\n\n\nUSER ACTIVITY\n\n\n")
//        if let incomingURL = userActivity.webpageURL{
//            print("incoming URL: \(incomingURL)")
//            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
//                guard error == nil else{
//                    print("Error handling dynamic link")
//                    return
//                }
//                if let dynamicLink = dynamicLink{
//                    self.handlePasswordlessSignIn(dynamicLink.url!)
//                }
//            }
//            return linkHandled
//        }
//        return false
//
////        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
//    }
}



