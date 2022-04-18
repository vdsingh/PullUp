//
//  SignUpController1.swift
//  PullUp
//
//  Created by Vikram Singh on 4/17/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class SignUpController1: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    //UI ELEMENT PARAMETERS
    let textFieldIconSize = 30
    let textFieldBorderWidth: CGFloat = 2
    let placeHolderColor: UIColor = .gray
    let backgroundColor: UIColor = .white
    
    
    //UI ELEMENTS
    @IBOutlet weak var fieldsBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //AUTHENTICATION STUFF
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideKeyboardWhenTappedAround()
        
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupUI(){
        let emailImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        emailImageView.image = UIImage(systemName: "envelope")
        emailImageView.contentMode = .scaleAspectFit

        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        emailView.addSubview(emailImageView)
        emailTextField.tintColor = .gray
        emailTextField.leftViewMode = UITextField.ViewMode.always
        emailTextField.leftView = emailView
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = textFieldBorderWidth
        
        let emailPlaceholderAttributedString = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        emailTextField.attributedPlaceholder = emailPlaceholderAttributedString
        emailTextField.backgroundColor = backgroundColor
        emailTextField.returnKeyType = .done
//        emailTextField.delegate = self
        
        //PASSWORD TEXT FIELD SETUP:
        let passwordIconImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordIconImageView.image = UIImage(systemName: "lock")
        passwordIconImageView.contentMode = .scaleAspectFit

        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordIconView.addSubview(passwordIconImageView)
        passwordTextField.leftView = passwordIconView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let passwordEyeImageView = UIImageView(frame: CGRect(x: -textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordEyeImageView.image = UIImage(systemName: "eye")
        passwordEyeImageView.contentMode = .scaleAspectFit

        let passwordEyeView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordEyeView.addSubview(passwordEyeImageView)
        passwordTextField.tintColor = .gray
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightView = passwordEyeView
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = textFieldBorderWidth
        
        let passwordPlaceholderAttributedString = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        passwordTextField.attributedPlaceholder = passwordPlaceholderAttributedString
        passwordTextField.backgroundColor = backgroundColor
        passwordTextField.returnKeyType = .done
//        passwordTextField.delegate = self
        
        //USERNAME TEXT FIELD SETUP:
        let usernameIconImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        usernameIconImageView.image = UIImage(systemName: "person")
        usernameIconImageView.contentMode = .scaleAspectFit

        let usernameIconView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        usernameIconView.addSubview(usernameIconImageView)
        usernameTextField.leftView = usernameIconView
        usernameTextField.leftViewMode = UITextField.ViewMode.always
        
        usernameTextField.tintColor = .gray
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.borderColor = UIColor.gray.cgColor
        usernameTextField.layer.borderWidth = textFieldBorderWidth
        
        let usernamePlaceholderAttributedString = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        usernameTextField.attributedPlaceholder = usernamePlaceholderAttributedString
        usernameTextField.backgroundColor = backgroundColor
        usernameTextField.returnKeyType = .done
//        usernameTextField.delegate = self
        
        fieldsBackground.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 10
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignUpController viewWillAppear")
        emailTextField.delegate = self
        ref = Database.database().reference()
                
        errorLabel.text = ""
        if(Auth.auth().currentUser != nil){
            print("Current user is NOT nil: \(Auth.auth().currentUser?.uid)")
            //find the courses that the user is in and add them to the courses array.
            
            self.performSegue(withIdentifier: K.signUpToMainSegue, sender: self)
        }else{
            print("Current user is nil")
        }
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil{
                //we are not signed in
                print("User is nil")
            }else{
                //we are signed in
                print("User is signed in!")
                
                self.performSegue(withIdentifier: K.signUpToMainSegue, sender: self)

//                if let email = user?.email {
//                    print("Email: \(email)")
//                if let user = user{
//                    self.ref.child("users").child(user.uid).child("username").setValue(self.usernameTextField.text!)
//                    self.ref.child("users").child(user.uid).child("email").setValue(self.emailTextField.text!)
//
//                }
//                }
                //update user information

            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove listener before we leave
        guard let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle else {return}
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        signUp()
    }
    
    func signUp(){
        view.endEditing(true)

        errorLabel.text = ""
        let email = emailTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        
        //get the school by splitting on @ and then on . For example with vdsingh@umass.edu, we separate into vdsingh and umass.edu . We then separate into umass and edu and take umass.
        var schoolComponents = email.components(separatedBy: "@")
        schoolComponents = schoolComponents[schoolComponents.count - 1].components(separatedBy: ".")
        let school = schoolComponents[schoolComponents.count - 2]
        
        
        //vdsingh@umass.edu
        if(email == "developer"){
            UserDefaults.standard.set(email, forKey: K.emailKey)
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error{
                    print("Error signing in as developer: \(error.localizedDescription)")
                }
            }
            return
        }
        
        //.umass
        if(email.count < 10 || !email.hasSuffix(".edu")){
            errorLabel.textColor = .red
            errorLabel.text = "Please enter an email address that ends with \".edu\""
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
        
        
        //sending sign in link
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
                print("Error with sign in link: \(error)")
//              self.showMessagePrompt(error.localizedDescription)
                return
            }
            
            // The link was successfully sent. Inform the user.
            print("Successfully sent email!")
            self.errorLabel.textColor = .green
            self.errorLabel.text = "Verify your email: we just sent an email with a verification link to \(email)."
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            print("Set UserDefaults email to \(email)")
            
            UserDefaults.standard.set(school, forKey: K.schoolKey)
            UserDefaults.standard.set(email, forKey: K.emailKey)
            UserDefaults.standard.set(username, forKey: K.usernameKey)
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            //user successfully signed out
        } catch let err{
            print("Error Signing Out: \(err.localizedDescription)")
            //error when signing out
        }
    }
    
    //if the user clicks "return" or "done" on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUp()
        return true
    }
}

