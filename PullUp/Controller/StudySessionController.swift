//
//  StudySessionController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
class StudySessionController: UIViewController{
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var courses: [String] = []
    var relevantLocations: [Location] = []
    
    @IBOutlet weak var sessionTableView: UITableView!
    override func viewDidLoad() {
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        //get all courses the user is in.
        ref.child("users").child(uid!).child("courses").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? [String: Bool]
            for key in value!.keys {
                if(value![key] == true){
                    self.courses.append(key)
                }
            }
        }) { error in
          print(error.localizedDescription)
        }

        databaseHandle = ref.child("locations").observe(.childAdded) { snapshot in
            //take the value from the snapshot and add it to courses
            let location = snapshot.value as? [String: Any]
            
            if let actualLocation = location{
                let courseString = actualLocation["course"] as! String
                //we have found a session for a course that user is in.
                if(self.courses.contains(courseString)){
                    print("Found a relevant location! for course \(courseString)")
                    self.relevantLocations.append(Location(latitude: actualLocation["latitude"] as? Double ?? 0, longitude: actualLocation["longitude"] as? Double ?? 0, locationDescription: actualLocation["locationDescription"] as? String ?? "", locationSubdescription: actualLocation["locationSubdescription"] as? String ?? "", courseString: courseString, colorHex: actualLocation["colorHex"] as? String ?? "ffff00"))
                }
            }
            self.sessionTableView.reloadData()
        }
        print("RELEVANT LOCATIONS: \(relevantLocations)")
    }
}

extension StudySessionController: UITableViewDelegate{
    
}

extension StudySessionController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relevantLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) 
        
        cell.textLabel?.text = relevantLocations[indexPath.row].courseString
        return cell
    }
}
