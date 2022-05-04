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

class SelectCourseController: UIViewController, UISearchControllerDelegate {

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
                
        tableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "courseCell")
//        ref =
        
        //get the courses that have already been selected so they can be selected upon tableview loading
        
        //look for courses being added so that we can add them to our course array.
//
        tableView.delegate = self
        tableView.dataSource = self

        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Classes"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePreexistingCourseData()
        courses = []
        databaseHandle = ref.child("courses").observe(.childAdded) { snapshot in
            //take the value from the snapshot and add it to courses
            let course = snapshot.value as? [String: String]
            if let course = course{
                self.courses.append(Course(title: course["title"] ?? "", colorHex: course["colorHex"] ?? "ffffff"))
            }
            self.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCourses = courses.filter (course: Course) -> Bool in
            return course.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
    //change this from storing key:boolean to just an array of keys.
    func updatePreexistingCourseData() -> Bool{
        preexistingCourseSelections = []
        guard let user = Auth.auth().currentUser else {return false}
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}

        let uid = user.uid
        ref.child(school).child("users").child(uid).child("courses").observeSingleEvent(of: .value, with: { snapshot in
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
        return true
    }
    

    
}

extension SelectCourseController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension SelectCourseController: UITableViewDelegate{
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
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return}
        let courseRef = ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("courses").child(courseTitle)
//        updatePreexistingCourseData()
        if(cell?.accessoryType == .checkmark){
            cell?.accessoryType = .none
//            cell?.backgroundColor = .red
            ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("courses").child(courseTitle).removeValue()
//            courseRef.setValue(false)
        }else{
            print("Adding course \(courseTitle)")
            courseRef.setValue(true)
            cell?.accessoryType = .checkmark

        }
        updatePreexistingCourseData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectCourseController: UITableViewDataSource{
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
