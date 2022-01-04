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
    @IBOutlet weak var errorLabel: UILabel!
    
//    var actionCodeSettings: ActionCodeSettings!
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
        let authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil{
                //we are not signed in
                print("User is nil")
            }
            if let user = user, let email = user.email{
                //we are signed in
            }
        }
    }
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        errorLabel.text = ""
        let email = emailTextField.text ?? ""
        
        //.umass
        if(email.count < 10 || !email.hasSuffix("@umass.edu")){
            errorLabel.textColor = .red
            errorLabel.text = "Please enter an email address that ends with \"@umass.edu\"."
            return
        }

        //Configuring ActionCodeSettings
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pullupapp.page.link"
        
        let emailURLQueryItem = URLQueryItem(name: "email", value: email)
        components.queryItems = [emailURLQueryItem]
        
        guard let linkParameters = components.url else {return}

        actionCodeSettings.url = linkParameters
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
                print(error)
//              self.showMessagePrompt(error.localizedDescription)
              return
            }
            
            // The link was successfully sent. Inform the user.
            print("Successfully sent email!")
            self.errorLabel.textColor = .green
            self.errorLabel.text = "Verify your email: we just sent an email with a verification link to \(email)."
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            UserDefaults.standard.set(email, forKey: K.emailKey)
//            print("Check email for link")
//            self.showMessagePrompt("Check your email for link")
            // ...
        }
    
    }
    
    
}
