//
//  FriendRequestsViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 4/20/22.
//

import Foundation
import UIKit
class FriendRequestsTableViewController: UITableViewController{
    
    let requests: [User] = [User(username: "vdsingh", name: "Vikram Singh", courses: [], profilePictureKey: "", uid: "5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FriendRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "requestCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! FriendRequestTableViewCell
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
}
