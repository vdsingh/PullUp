//
//  SettingsController.swift
//  PullUp
//
//  Created by Vikram Singh on 1/8/22.
//

import Foundation
import UIKit
import FirebaseAuth
class SettingsController: UITableViewController{
    
    let settingsOptions = ["Help", "Sign Out"]
    override func viewDidLoad() {
        print("Entered Settings")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! UITableViewCell
//        cell.text = settingsOptions[indexPath.row]
        cell.textLabel?.text = settingsOptions[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(settingsOptions[indexPath.row] == "Sign Out"){
            signOut()
//            self.navigationController?.popToRootViewController(animated: true)
//            let viewController = self.navigationController?.viewControllers.first {$0 is SignUpController}
//            guard let destinationVC = viewController else {
//                print("Destination is nil")
//                return
//            }
//            self.navigationController?.popToViewController(destinationVC, animated: true)
            self.performSegue(withIdentifier: "unwindSegue", sender: self)

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            print("Signed Out")
        } catch let err{
            print("Error Signing Out: \(err.localizedDescription)")
        }
    }
}
