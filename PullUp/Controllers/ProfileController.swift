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
    var user: User = User.createBasicSelf()
    var currentSession: Location? = nil
    
    @IBOutlet weak var currentSessionTableView: UITableView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        currentSessionTableView.register(UINib(nibName: "SessionTableViewCell", bundle: nil), forCellReuseIdentifier: "sessionCell")
        currentSessionTableView.delegate = self
        currentSessionTableView.dataSource = self
        currentSessionTableView.setEditing(true, animated: true)
        
        DatabaseManager.getSessionFromUser(user: user) { location in
            self.currentSession = location
            self.currentSessionTableView.reloadData()
            print("LOG: currentSession: \(self.currentSession)")
        }
    }
    
    func loadUser(){
        defaultUISetup()
        if(user.isSelf()){
            print("LOG: USER IS SELF")
            //add a gesture that allows user to change profile picture
            let gesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
            profilePictureImageView.addGestureRecognizer(gesture)
            
            //set the color of the editProfileButton to maroon
            editProfileButton.backgroundColor = K.maroonColor
            editProfileButton.setTitle("Edit Profile", for: .normal)
//            loadOwnProfile()
        }else{
            print("LOG: USER IS NOT SELF: \(user)")
            editProfileButton.backgroundColor = .green
            editProfileButton.setTitle("Send Request", for: .normal)
        }
    }
    
//    func loadOwnProfile(){
//        let username = UserDefaults.standard.value(forKey: K.usernameKey)! as! String
//        usernameLabel.text = "@\(username)"
        
//        let name = UserDefaults.standard.value(forKey: K.nameKey)! as! String
//        nameLabel.text = name
        
//        let profileImage: UIImage = UIImage(named: "stock_profile") ?? UIImage(systemName: "person") as! UIImage
//        profilePictureImageView.image = profileImage
        
//    }
    
    func defaultUISetup(){
        profilePictureImageView.layer.borderWidth = 3.0
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView?.layer.borderColor = UIColor.white.cgColor
        
        let profileImagePath = "images/\(user.safeEmail)_profile_picture.png"
        print("LOG: profileImagePath: \(profileImagePath)")
        StorageManager.shared.downloadURL(for: profileImagePath, completion: { [weak self] result in
            switch result{
            case .success(let url):
                self?.downloadImage(imageView: self!.profilePictureImageView, url: url)
                print("LOG: success getting downloadURL")
            case .failure(let error):
                print("ERROR: failed to getdownload url: \(error)")
            }
        })
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.tintColor = .white
        
        let username = user.username
        usernameLabel.text = "@\(username)"
        
        let name = user.name
        nameLabel.text = name
        
    }
    
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else{
                print("ERROR: something went wrong when downloading image. Data was nil or error wasn't nil.")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    
    @objc private func didTapChangeProfilePic(){
        print("Change profile pic called.")
        presentPhotoActionSheet()
    }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        //EDIT PROFILE
        if(user.isSelf()){
            
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
        
        let targetUID = user.uid
        
        ref.child(school).child("users").child(targetUID!).child("requests").setValue(["uid": currentUserUID, "username": username])
        
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
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let data = selectedImage.pngData() else {
            print("ERROR: something was nil in profile controller.")
            return
        }
        self.profilePictureImageView.image = selectedImage
        
        //        let data = selectedImage.pngData()
        let fileName = user.profilePictureFileName
        StorageManager.shared.uploadProfilePicture(data: data, fileName: fileName) { result in
            switch result {
            case .success(let downloadURL):
//                UserDefaults.standard.set(downloadURL, forKey: K.profilePictureURLKey)
                print(downloadURL)
//                self.ref = Database.database().reference()
//                self.ref.child(self.user.school).child("users").child(self.user.safeEmail).child("profilePictureURL").setValue(downloadURL)
            case .failure(let error):
                print("ERROR: storageManager Error: \(error)")
            }
        }
        
    }
}


extension ProfileController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("LOG: Cellforrowat")
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell
        if let currentSession = currentSession{
            cell.setUpData(location: currentSession)
            print("LOG: set up data for currentSession complete.")
        }else{
            print("LOG: currentSession is nil.")
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

