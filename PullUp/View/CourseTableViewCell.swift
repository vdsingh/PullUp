//
//  CourseTableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 11/7/21.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var coursePinImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(course: Course){
        coursePinImageView.tintColor = UIColor(course.colorHex)
        courseNameLabel.text = course.title
    }
    
}
