//
//  SearchUserTableViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import Foundation
import UIKit
class SearchUserTableViewController: UITableViewController{
    
    let users: [User] = DummyData.users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")

        print(users)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        return true;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        userCell.loadUser(user: users[indexPath.row])
        return userCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProfileScreen", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var destinationVC = segue.destination as? ProfileController {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.user = users[indexPath.row]
            }
        }
    }
}
