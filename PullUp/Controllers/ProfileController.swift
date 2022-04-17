//
//  ProfileController.swift
//  PullUp
//
//  Created by Vikram Singh on 12/31/21.
//

import Foundation
import UIKit
class ProfileController: UIViewController{
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var numFriendsLabel: UILabel!
    
    
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        emailLabel.text = UserDefaults.standard.value(forKey: K.emailKey) as? String
        
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
