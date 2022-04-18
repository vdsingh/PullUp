//
//  ProfileController.swift
//  PullUp
//
//  Created by Vikram Singh on 12/31/21.
//

import Foundation
import UIKit
class ProfileController: UIViewController{
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var numFriendsLabel: UILabel!
    
    
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String
        usernameLabel.text = "@\(username)"
        
        let profileImage: UIImage = UIImage(named: "stock_profile") ?? UIImage()
        profilePictureImageView.image = profileImage
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView?.layer.borderWidth = 3.0
        profilePictureImageView?.layer.borderColor = UIColor.white.cgColor
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.backgroundColor = K.maroonColor
        editProfileButton.tintColor = .white
    }
    
}
