//
//  SearchUserTableViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import Foundation
import UIKit
class SearchUserTableViewController: UITableViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        return true;
    }
    
}
