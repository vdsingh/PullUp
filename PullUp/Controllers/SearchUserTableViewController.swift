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
    //the users that are visible in the tableView (will be filled with the loadUsers function)
    var users: [User] = []
    
    //Firebase stuff
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    //Pull to refresh functionality
    let myRefreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        

        tableView.register(UINib(nibName: "RequestsTableViewCell", bundle: nil), forCellReuseIdentifier: "requestsCell")
        
//        myRefreshControl = UIRefreshControl()
        myRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        myRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(myRefreshControl) // not required when using UITableViewController

        
        if(!loadUsers()){
            //There was an error loading users.
            print("There was an error loading users.")
        }
        print("Users loaded: \(users)")
        tableView.reloadData()
        print(users)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        refreshControl?.endRefreshing()
//        return
    }
    
    func loadUsers() -> Bool{
        //GET THE CURRENT USER'S INFORMATION TO PATH THROUGH THE FIREBASE
        guard let email = UserDefaults.standard.value(forKey: K.emailKey) as? String else {return false}
        guard let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String else {return false}
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}
        
        ref = Database.database().reference()
        guard let currentUser = Auth.auth().currentUser else {
            print("ERROR: currentUser is nil while trying to load MapView")
            return false
        }
            
        print("LOG: loading users.")
        //get all users in the current user's school.
        ref.child(school).child("users").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            guard let object = snapshot.value as? [String: Any] else {return}
            print("object: \(object)")
            for key in object.keys {
                print("KEY: \(key)")
                //THIS USER IS THE CURRENT USER. LEAVE THEM OUT
                if(key == currentUser.uid){
                    continue
                }
                let user = User(username: object["username"] as? String ?? "", name: object["name"] as? String ?? "", courses: nil, profilePictureKey: "default_profile", uid: key)
//                print("RES: \(res)")
                self.users.append(user)
//                if(value[key] == true){
//                    self.users.append(key)
//                    print("added \(key) to courses")
//                }
            }
            self.tableView.reloadData()
        }) { error in
          print("Error adding courses: \(error.localizedDescription)")
//            return false
        }
//        print("RES: \(res)")
//        return res
        return true
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
        if indexPath.section == 0{
            //CLICKED ON FRIEND REQUESTS LIST
            performSegue(withIdentifier: "toRequestsScreen", sender: self)
        }else{
            //CLICKED ON A USER'S PROFILE
            performSegue(withIdentifier: "toProfileScreen", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProfileController {
            if let indexPath = tableView.indexPathForSelectedRow{
                print("SETTING DESTINATION USER")
                destinationVC.user = users[indexPath.row]
            }else{
                print("ERROR: error getting indexPath when seguing to profile screen.")
            }
        }else{
            print("ERROR: destination viewcontroller is nil when trying to segue to profile screen.")
        }
    }
}
