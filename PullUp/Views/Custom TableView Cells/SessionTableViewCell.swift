//
//  SessionTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 11/7/21.
//

import UIKit
import SwipeCellKit

class SessionTableViewCell: SwipeTableViewCell{
    

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
//    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var pinButton: UIButton!
    
    var session: Location?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pinButton.setTitle("", for: .normal)
        pinButton.imageView!.contentMode = .scaleAspectFit
        pinButton.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(location: Location){
        self.session = location
        locationLabel.text = location.locationDescription
        actionLabel.text = "Working on \(location.sessionGoal)"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm a"
//        var dateFromStr = dateFormatter.string(from: location.timeFinishString)
        print("Setting locations finish time to \(location.timeFinishString)")
        let formatter = DateFormatter()
        formatter.dateFormat = K.dateFormatString
        guard let date = formatter.date(from: location.timeFinishString) else {
            return
            print("FATAL: could not convert from date string to date in SessionCell")
        }
        formatter.dateFormat = "MMM d, h:mm a"
        timeLabel.text = formatter.string(from: date)
        

        
//        timeLabel.text = location.timeFinishString
        
//        timeLabel.text = "" + location.timeFinish.formatted("HH:m
//                                                            m a")
//        location.timeFinish.form
        courseNameLabel.text = location.courseString
//        pinImageView.tintColor = UIColor(location.colorHex)
        
    }
    
}
