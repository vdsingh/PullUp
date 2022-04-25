//
//  FriendRequestsViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/20/22.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
class FriendRequestsTableViewController: UITableViewController{
    
    //REFERENCE TO THE DATABASE
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    let requests: [User] = [User(username: "vdsingh", name: "Vikram Singh", courses: [], profilePictureKey: "", uid: "5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delaysContentTouches = false
        tableView.register(UINib(nibName: "FriendRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "requestCell")
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "testCell")

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = requests[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") as! TestTableViewCell
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! FriendRequestTableViewCell
        requestCell.delegate = self
        requestCell.loadUser(user: user)
        return requestCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FriendRequestsTableViewController: RequestHandler{
    func handleAcceptRequest(user: User) -> Bool{
        guard let currentUser = Auth.auth().currentUser else {
            print("ERROR: currentUser is nil while trying to load profile")
            return false
        }
        
        let selfUID = currentUser.uid
        let targetUID = user.uid

        guard let selfUsername = UserDefaults.standard.value(forKey: K.usernameKey) as? String else {return false}
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}
        
        ref = Database.database().reference()
        ref.child(school).child("users").child(targetUID).child("friends").setValue([selfUsername: currentUser.uid])
        ref.child(school).child("users").child(selfUID).child("friends").setValue([user.username: targetUID])

        
        return true
    }
    
    func handleDeclineRequest(user: User) -> Bool{
        
        
        return false
        
    }
    
    
}
