//
//  ProfileController.swift
//  PullUp
//
//  Created by Vikram Singh on 12/31/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ProfileController: UIViewController{
    var user: User? = nil
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var numFriendsLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        loadUser()
    }
    
    func loadUser(){
        defaultUISetup()
        if(user == nil){
            loadOwnProfile()
        }else{
            let username = user!.username
            usernameLabel.text = "@\(username)"
            
            let profileImage: UIImage = UIImage(named: user!.profilePictureKey) ?? UIImage()
            profilePictureImageView.image = profileImage
            
            let name = user!.name
            nameLabel.text = name
            
            editProfileButton.backgroundColor = K.maroonColor
//            editProfileButton.titleLabel!.text = "Send Request"
            editProfileButton.setTitle("Send Request", for: .normal)
        }
    }
    
    func loadOwnProfile(){
        let username = UserDefaults.standard.value(forKey: K.usernameKey)! as! String
        usernameLabel.text = "@\(username)"
        
        let profileImage: UIImage = UIImage(named: "stock_profile") ?? UIImage()
        profilePictureImageView.image = profileImage
        
        editProfileButton.backgroundColor = K.maroonColor
    }
    
    func defaultUISetup(){
        profilePictureImageView.layer.borderWidth = 3.0
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView?.layer.borderColor = UIColor.white.cgColor

        editProfileButton.layer.cornerRadius = 10
        editProfileButton.tintColor = .white

    }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        //EDIT PROFILE
        if(user == nil){
            
        }else{
            let requestStatus = sendRequest()
            if(requestStatus == false){
                print("ERROR: request not sent. There was an error.")
            }
        }
        
    }
    
    //returns True if successfully sent request. False if not.
    func sendRequest() -> Bool{
//        targetUsername = user?.username
        ref = Database.database().reference()
        guard let currentUser = Auth.auth().currentUser else {
            print("FATAL: currentUser is nil while trying to load profile")
            return false
        }
        
        let currentUserUID = currentUser.uid
//        guard let email = UserDefaults.standard.value(forKey: K.emailKey) as? String else {return false}
        guard let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String else {return false}
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}
        
        let targetUID = user!.uid
        
        ref.child(school).child("users").child(targetUID).child("requests").setValue(["uid": currentUserUID, "username": username])
        
        return true
    }
}
