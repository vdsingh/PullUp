//
//  AddCourseController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
import MapKit
class AddCourseController: UIViewController, UISearchControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController()
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let courses: [String] = ["CS121", "CS187", "CS220", "CS230","CS240", "CS250"]
    var filteredCourses: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Classes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCourses = courses.filter{(course: String) -> Bool in
            return course.lowercased().contains(searchText.lowercased())
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
        if(cell?.accessoryType == .checkmark){
            cell?.accessoryType = .none
        }else{
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
//        cell.textLabel?.text = courses[indexPath.row]
//
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        let course: String
        if isFiltering {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        cell.textLabel?.text = course
        return cell
    }
    
    
}
