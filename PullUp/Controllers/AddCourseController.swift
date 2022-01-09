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
    lazy var ref: DatabaseReference! = {
        Database.database().reference()
    }()
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
        updatePreexistingCourseData()
        
//        print("CURRENT USER: \(Auth.auth().currentUser)")
        
        tableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "courseCell")
//        ref =
        
        //get the courses that have already been selected so they can be selected upon tableview loading
        
        //look for courses being added so that we can add them to our course array.
        databaseHandle = ref.child("courses").observe(.childAdded) { snapshot in
//            print("Child added to courses")
            //take the value from the snapshot and add it to courses
            let course = snapshot.value as? [String: String]
//            print("Course \(course)")
            if let course = course{
//                print("Course: \(actualCourse)")
                self.courses.append(Course(title: course["title"] ?? "", colorHex: course["colorHex"] ?? "ffffff"))
            }
//            print("Courses: \(self.courses)")
            self.tableView.reloadData()
        }
        
//
        tableView.delegate = self
        tableView.dataSource = self
//
//        navigationController?.navigationBar.barTintColor = .purple
//        navigationController?.toolbar.barTintColxor = .purple
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Classes"
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCourses = courses.filter{(course: Course) -> Bool in
            return course.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
    //change this from storing key:boolean to just an array of keys.
    func updatePreexistingCourseData(){
        preexistingCourseSelections = []
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        ref.child("users").child(uid).child("courses").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: Bool]
            //convert the dictionary into an array of keys
            if(value != nil){
                for key in value!.keys{
                    if(value![key] == true){
                        self.preexistingCourseSelections.append(key)
                    }
                }
            }
        }) { error in
          print(error.localizedDescription)
        }
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
        print(filteredCourses)
        
        //if we are searching, use the filteredCourses array to get the course title. If not, use the total course array
        let courseTitle = filteredCourses.count == 0 ? courses[indexPath.row].title: filteredCourses[indexPath.row].title
        
        guard let user = Auth.auth().currentUser else{
            print("FATAL: user is nil!")
            return
        }
        let uid = user.uid
        let courseRef = ref.child("users").child(uid).child("courses").child(courseTitle)
//        updatePreexistingCourseData()
        if(cell?.accessoryType == .checkmark){
            cell?.accessoryType = .none
            ref.child("users").child(uid).child("courses").child(courseTitle).removeValue()
//            courseRef.setValue(false)
        }else{
            print("Adding course \(courseTitle)")
//            if(courses.count >= 10){
//                let alert = UIAlertController(title: "Course Limit", message: "You can't add more than 10 courses.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }else{
            courseRef.setValue(true)
            cell?.accessoryType = .checkmark
//            }
        }
        updatePreexistingCourseData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell
        let course: Course
        if isFiltering {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        
//        cell.textLabel?.text = course.title
        cell.setUpData(course: course)
//        print("Preexisting\(preexistingCourseSelections)")
        if(preexistingCourseSelections.contains(course.title)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    
}
