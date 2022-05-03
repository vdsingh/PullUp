//
//  TableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var mutualsLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadUser(user: User){
        print("USERS NAME IS \(user.name)")
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.image = UIImage(named: "stock_profile2")
//        nameLabel.text =
//        nameLabel.s
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        
    }
}
