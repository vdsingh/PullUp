//
//  FriendRequestTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/20/22.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptButton.layer.cornerRadius = 10
        declineButton.layer.cornerRadius = 10
        acceptButton.backgroundColor = .green
        declineButton.backgroundColor = .red
        acceptButton.tintColor = .white
        declineButton.tintColor = .white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
