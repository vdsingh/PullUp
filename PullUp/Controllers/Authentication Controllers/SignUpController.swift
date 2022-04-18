////
////  SignUpController.swift
////  PullUp
////
////  Created by Vikram Singh on 12/29/21.
////
//
//import Foundation
//import UIKit
//import FirebaseAuth
//import FirebaseDatabase
//import FirebaseFirestore
//
//class SignUpController: UIViewController, UITextFieldDelegate{
//
//
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var errorLabel: UILabel!
//
//    var ref: DatabaseReference!
//    var databaseHandle: DatabaseHandle!
//
//    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
//
////    var actionCodeSettings: ActionCodeSettings!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
//
////        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
////        view.addGestureRecognizer(tap)
//
////        AppDelega /te.errorDelegate = self
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("SignUpController viewWillAppear")
//        emailTextField.delegate = self
//        ref = Database.database().reference()
//
////        signOut()
//
//        errorLabel.text = ""
//        if(Auth.auth().currentUser != nil){
//            print("Current user is NOT nil: \(Auth.auth().currentUser?.uid)")
//            self.performSegue(withIdentifier: K.signUpToMainSegue, sender: self)
//        }else{
//            print("Current user is nil")
//        }
//        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
//            if user == nil{
//                //we are not signed in
//                print("User is nil")
//            }else{
//                //we are signed in
//                print("User is signed in!")
//                self.performSegue(withIdentifier: K.signUpToMainSegue, sender: self)
//                //update user information
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        //remove listener before we leave
//        guard let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle else {return}
//        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
//    }
//
//
//    @IBAction func SignInPressed(_ sender: Any) {
//        signIn()
//    }
//
//    func signIn(){
//        view.endEditing(true)
//
//        errorLabel.text = ""
//        let email = emailTextField.text ?? ""
////        let username = usernameText
//        if(email == "developer"){
//            UserDefaults.standard.set(email, forKey: K.emailKey)
//            Auth.auth().signInAnonymously { authResult, error in
//                if let error = error{
//                    print("Error signing in as developer: \(error.localizedDescription)")
//                }
//            }
//            return
//        }
//
//        //.umass
//        if(email.count < 10 || !email.hasSuffix("@umass.edu")){
//            errorLabel.textColor = .red
//            errorLabel.text = "Please enter an email address that ends with \"@umass.edu\"."
//            return
//        }
//
//        //Configuring ActionCodeSettings
//        let actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "pullupapp.page.link"
//
//        let emailURLQueryItem = URLQueryItem(name: "email", value: email)
//        components.queryItems = [emailURLQueryItem]
//
//        guard let linkParameters = components.url else {return}
//
//        actionCodeSettings.url = linkParameters
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//
////        dismissKeyboard()
//
//        //sending sign in link
//        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
//          // ...
//            if let error = error {
//                print("Error with sign in link: \(error)")
////              self.showMessagePrompt(error.localizedDescription)
//                return
//            }
//
//            // The link was successfully sent. Inform the user.
//            print("Successfully sent email!")
//            self.errorLabel.textColor = .green
//            self.errorLabel.text = "Verify your email: we just sent an email with a verification link to \(email)."
//            // Save the email locally so you don't need to ask the user for it again
//            // if they open the link on the same device.
//            print("Set UserDefaults email to \(email)")
//            UserDefaults.standard.set(email, forKey: K.emailKey)
//            UserDefaults.standard.set(username, forKey: K.usernameKey)
//
//        }
//    }
//
//    func signOut(){
//        do{
//            try Auth.auth().signOut()
//            //user successfully signed out
//        } catch let err{
//            print("Error Signing Out: \(err.localizedDescription)")
//            //error when signing out
//        }
//    }
//
//    //if the user clicks "return" or "done" on the keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        signIn()
//        return true
//    }
//}
//
//
