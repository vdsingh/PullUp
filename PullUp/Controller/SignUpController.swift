//
//  SignUpController.swift
//  PullUp
//
//  Created by Vikram Singh on 12/29/21.
//

import Foundation
import UIKit
import FirebaseAuth
class SignUpController: UIViewController{
    
//https://www.youtube.com/watch?v=KLBjAg6HvG0
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var actionCodeSettings: ActionCodeSettings!
    override func viewDidLoad() {
        actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://pullup-8c562.firebaseapp.com")
//        actionCodeSettings.continueUR
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//        actionCodeSettings.setAndroidPackageName("com.example.android",
//                                                 installIfNotAvailable: false, minimumVersion: "12")
    }
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        let email = emailTextField.text
        Auth.auth().sendSignInLink(toEmail: email!, actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
                print(error)
//              self.showMessagePrompt(error.localizedDescription)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            UserDefaults.standard.set(email, forKey: "Email")
            print("Check email for link")
//            self.showMessagePrompt("Check your email for link")
            // ...
        }
    
    }
    
    
}
