//
//  AddCourseController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import MapKit
//import RealmSwift
class AddCourseController: UIViewController, UISearchControllerDelegate {
//    var realm: Realm!
//    let app = App(id: "pullup-txctd")
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController()

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var courses: [Course] = []
    var filteredCourses: [Course] = []
    
    var preexistingCourseSelections: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        //get the courses that have already been selected so they can be selected upon tableview loading
        ref.child("users").child(uid!).child("courses").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: Bool]
            print("VALUEEEEE \(value)")
            //convert the dictionary into an array of keys
            for key in value!.keys{
                if(value![key] == true){
                    self.preexistingCourseSelections.append(key)
                }
            }
        }) { error in
          print(error.localizedDescription)
        }
        
        databaseHandle = ref.child("courses").observe(.childAdded) { snapshot in
//            print("Child added to courses")
            //take the value from the snapshot and add it to courses
            let course = snapshot.value as? [String: String]
//            print("Course \(course)")
            if let actualCourse = course{
//                print("Course: \(actualCourse)")
                self.courses.append(Course(title: actualCourse["title"] ?? "", colorHex: actualCourse["colorHex"] ?? "ffffff"))
            }
//            print("Courses: \(self.courses)")
            self.tableView.reloadData()
        }
        
        title = "Search"
//
        tableView.delegate = self
        tableView.dataSource = self
//
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Classes"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCourses = courses.filter{(course: Course) -> Bool in
            return course.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension AddCourseController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension AddCourseController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let courseTitle = courses[indexPath.row].title
        
        let uid = Auth.auth().currentUser?.uid
        let thisUsersGamesRef = self.ref.child("users").child(uid!).child("courses").child(courseTitle)

        if(cell?.accessoryType == .checkmark){
            cell?.accessoryType = .none
            thisUsersGamesRef.setValue(false)
        }else{
            
            print("Adding title \(courseTitle)")
            thisUsersGamesRef.setValue(true)

            cell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddCourseController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCourses.count
        }
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        let course: Course
        if isFiltering {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        
        cell.textLabel?.text = course.title
        print("Preexisting\(preexistingCourseSelections)")
        if(preexistingCourseSelections.contains(course.title)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    
}
