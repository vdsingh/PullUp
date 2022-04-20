//
//  RequestsTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/20/22.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendRequestsLabel: UILabel!
    var numRequests = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNumRequests(numRequests: Int){
        self.numRequests = numRequests
    }
}
