//
//  SceneDelegate.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import UIKit

import FirebaseDynamicLinks
import FirebaseAuth
import Firebase
//import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("\n\n\nUSER ACTIVITY\n\n\n")
        if let incomingURL = userActivity.webpageURL{
            print("incoming URL: \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                guard error == nil else{
                    print("Error handling dynamic link")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handlePasswordlessSignIn(dynamicLink.url!)
                    
                }
            }
        }
    }
    
    func handlePasswordlessSignIn(_ withURL: URL) -> Bool{
        print("handling passwordless sign in")
//        DynamicLink().ur
        let link = withURL.absoluteString
        
        if Auth.auth().isSignIn(withEmailLink: link){
            guard let email = UserDefaults.standard.value(forKey: K.emailKey) as? String else {return false}
            guard let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String else {return false}
            guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}
            guard let name = UserDefaults.standard.value(forKey: K.nameKey) as? String else {return false}

            Auth.auth().signIn(withEmail: email, link: link) { (result, error) in
                if let error = error{
                    var errorString = error.localizedDescription
                    print("Error signing in: \(errorString)")
                    if(errorString == "The action code is invalid. This can happen if the code is malformed, expired, or has already been used."){
                        errorString = "The link you used is expired. Please use the most recent link or re-enter your email to receive another verification link."
                    }
                    let alert = UIAlertController(title: "Error Signing In", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let result = result else {return}
                let user = result.user
                print("user signed in: \(user.email)")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = K.dateFormatString
                let timestamp = dateFormatter.string(from: Date())
                
                print("SCHOOL: \(school)")
                
                //record the user's email and the timestamp of last signed in.
//                ref.setValue(school)
                let ref = Database.database().reference()
                let safeEmail = User.safeEmail(emailAddress: email)
                ref.child(school).child("users").child(safeEmail).child("email").setValue(email)
                ref.child(school).child("users").child(safeEmail).child("username").setValue(username)
                ref.child(school).child("users").child(safeEmail).child("timestamp").setValue(timestamp)
                ref.child(school).child("users").child(safeEmail).child("name").setValue(name)
                ref.child(school).child("users").child(safeEmail).child("uid").setValue(user.uid)
            }
        }else{
            
        }
        return true
    }
    
}

