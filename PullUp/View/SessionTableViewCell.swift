//
//  SessionTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 11/7/21.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpDate(location: Location){
        locationLabel.text = location.locationDescription
        actionLabel.text = "Working on \(location.sessionGoal)"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm a"
//        var dateFromStr = dateFormatter.string(from: location.timeFinishString)
        print("Setting locations finish time to \(location.timeFinishString)")
        timeLabel.text = location.timeFinishString
        
//        timeLabel.text = "" + location.timeFinish.formatted("HH:m
//                                                            m a")
//        location.timeFinish.form
        courseNameLabel.text = location.courseString
        pinImageView.tintColor = UIColor(location.colorHex)
        
    }
    
}
