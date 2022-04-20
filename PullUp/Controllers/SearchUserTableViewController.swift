//
//  SearchUserTableViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
class SearchUserTableViewController: UITableViewController{
    
    let users: [User] = DummyData.users
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        tableView.register(UINib(nibName: "RequestsTableViewCell", bundle: nil), forCellReuseIdentifier: "requestsCell")

        print(users)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        return true;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let requestsCell = tableView.dequeueReusableCell(withIdentifier: "requestsCell") as! RequestsTableViewCell
            return requestsCell
        }else{
            let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
            userCell.loadUser(user: users[indexPath.row])
            return userCell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return users.count
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 50
        }else{
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            //CLICKED ON FRIEND REQUESTS LIST
            performSegue(withIdentifier: "toRequestsScreen", sender: self)
        }else{
            //CLICKED ON A USER'S PROFILE
            performSegue(withIdentifier: "toProfileScreen", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProfileController {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.user = users[indexPath.row]
            }
        }
    }
}
