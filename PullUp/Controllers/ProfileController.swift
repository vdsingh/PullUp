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
import grpc

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
            print("LOG: USER IS SELF")
            loadOwnProfile()
        }else{
            print("LOG: USER IS NOT SELF: \(user)")
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
        
        let name = UserDefaults.standard.value(forKey: K.nameKey)! as! String
        nameLabel.text = name
        
        let profileImage: UIImage = UIImage(named: "stock_profile") ?? UIImage(systemName: "person") as! UIImage
        profilePictureImageView.image = profileImage
        let gesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        profilePictureImageView.addGestureRecognizer(gesture)
        
        editProfileButton.backgroundColor = K.maroonColor
    }
    
    func defaultUISetup(){
        profilePictureImageView.layer.borderWidth = 3.0
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView?.layer.borderColor = UIColor.white.cgColor
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.tintColor = .white

    }
    
    @objc private func didTapChangeProfilePic(){
        print("Change profile pic called.")
        presentPhotoActionSheet()
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

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a profile picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profilePictureImageView.image = selectedImage
    }
}
