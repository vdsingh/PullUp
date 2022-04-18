//
//  SignUpController1.swift
//  PullUp
//
//  Created by Vikram Singh on 4/17/22.
//

import Foundation
import UIKit
class SignUpController1: UIViewController, UIGestureRecognizerDelegate{
    
    let textFieldIconSize = 30
    let textFieldBorderWidth: CGFloat = 2
    let placeHolderColor: UIColor = .gray
    let backgroundColor: UIColor = .white
    
    
    @IBOutlet weak var fieldsBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
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
    
}

