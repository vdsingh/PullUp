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
    
    override func viewDidLoad() {
        emailLabel.text = UserDefaults.standard.value(forKey: K.emailKey) as? String
        
    }
    
}
