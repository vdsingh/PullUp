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
            Auth.auth().signIn(withEmail: email, link: link) { (result, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let result = result else {return}
                let user = result.user
                print("user signed in: \(user.email)")
                let ref = Database.database().reference()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = K.dateFormatString
                let timestamp = dateFormatter.string(from: Date())
                
                ref.child("users").child(user.uid).child("email").setValue(email)
                ref.child("users").child(user.uid).child("timestamp").setValue(timestamp)

            }
        }else{
            
        }
        return true
    }
}

