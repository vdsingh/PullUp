//
//  TableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var mutualConnectionsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadUser(user: User){
        self.nameLabel.text = user.name
        self.tagLabel.text = user.tag
    }
}
