//
//  StartViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/17/22.
//

import Foundation
import UIKit
class StartViewController: UIViewController{
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
    }
}
