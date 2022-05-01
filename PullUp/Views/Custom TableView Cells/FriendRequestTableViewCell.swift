//
//  FriendRequestTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/20/22.
//

import UIKit

//This protocol is for a TableViewController that is going to handle the logic for accepting/declining friend requests. This will involve removing the cell after accept or decline is clicked and also working with the database to update the changes to the users' data.
protocol RequestHandler: UITableViewController{
    func handleAcceptRequest(user: User) -> Bool
    func handleDeclineRequest(user: User) -> Bool
}

class FriendRequestTableViewCell: UITableViewCell {
    
    var user: User?
    var delegate: RequestHandler?

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    //    @IBOutlet weak var acceptButton: UIButton!
//    @IBOutlet weak var declineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()


        acceptButton.layer.cornerRadius = 10
        declineButton.layer.cornerRadius = 10
        acceptButton.backgroundColor = .green
        declineButton.backgroundColor = .red
        acceptButton.tintColor = .white
        declineButton.tintColor = .white
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadUser(user: User){
        self.user = user
    }


    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        print("accept button pressed")
        if let delegate = delegate{
            if let user = self.user{
                delegate.handleAcceptRequest(user: user)
            }else{
                print("ERROR: user is nil when trying to accept request (FriendRequestTableViewCell)")
            }
        }else{
            print("ERROR: delegate is nil when trying to accept request (FriendRequestTableViewCell)")
        }
    }
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        print("decline button pressed")
        if let delegate = delegate{
            if let user = self.user{
                delegate.handleDeclineRequest(user: user)
            }else{
                print("ERROR: user is nil when trying to decline request (FriendRequestTableViewCell)")
            }
        }else{
            print("ERROR: delegate is nil when trying to decline request (FriendRequestTableViewCell)")
        }
    }
}
