//
//  MapController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
import MapKit
import Firebase
import FirebaseAuth
import CoreMedia

import SwipeCellKit


class MapController: UIViewController, SwipeTableViewCellDelegate{
    
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            handleAuthorizationStatus(locationManager: locationManager, status: CLLocationManager.authorizationStatus())
        }
        return locationManager
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sessionsTableView: UITableView!
    
    
    let locationDistance: Double = 1000
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var relevantLocations: [Location] = []
    var friendsOnlyLocations: [Location] = []
    
    var friendSafeEmails: [String] = []
    
    var addedLocationIDs: [String] = []
    var colorDict: [String: String] = [:]
    
    var annotations: [MKPointAnnotation] = []
//    var courseDictionary: [String: Bool] = [:]
    var courses: [String] = []
    
    var onlyFriendGroups: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        sessionsTableView.dataSource = self
        sessionsTableView.delegate = self
        locationManager.startUpdatingLocation()
        
        //register session cells
        sessionsTableView.register(UINib(nibName: "SessionTableViewCell", bundle: nil), forCellReuseIdentifier: "sessionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(annotations)
        relevantLocations = []
        addedLocationIDs = []
        courses = []
        
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return}

        ref = Database.database().reference()
        guard let currentUser = Auth.auth().currentUser else {
            print("ERROR: currentUser is nil while trying to load MapView")
            return
        }
        let uid = currentUser.uid
        
        //find all the current user's friends so that we can filter out non-friend sessions
        ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("friends").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: String] else {return}
            for email in value.keys {
                self.friendSafeEmails.append(email)
            }
        }) {error in
            print("ERROR: error finding friends: \(error.localizedDescription)")
        }
            
        //find the courses that the user is in and add them to the courses array.
        ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("courses").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            guard let value = snapshot.value as? [String: Bool] else {return}
            for key in value.keys {
                if(value[key] == true){
                    self.courses.append(key)
                    print("LOG: added \(key) to courses")
                }
            }
        }) { error in
          print("ERROR: error adding courses: \(error.localizedDescription)")
        }

        //monitor the changes of study sessions.
        ref.child(school).child("sessions").observe(.childAdded) { snapshot in
            self.handleDataChanges(snapshot: snapshot)
            self.sessionsTableView.reloadData()
        }
        //monitor the changes of addition to user's courses
        ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("courses").observe(.childAdded, with: { snapshot in
            self.handleDataChanges(snapshot: snapshot)
            self.sessionsTableView.reloadData()
        })
        
        //monitor the changes of removal from the users's courses
        ref.child(school).child("users").child(User.createBasicSelf().safeEmail).child("courses").observe(.childRemoved, with: { snapshot in
            self.handleDataChanges(snapshot: snapshot)
            self.sessionsTableView.reloadData()
        })
    }
    
    func addPin(location: Location){
        print("adding location \(location.locationDescription)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
        annotation.title = location.locationDescription
        annotation.subtitle = location.courseString
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func centerViewToLocation(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        mapView.setRegion(region, animated: true)
    }
    
    func handleAuthorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus){
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Location is restricted")
            break
        case .denied:
            print("Location is denied")
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            if let center = locationManager.location?.coordinate{
                centerViewToLocation(coordinate: center)
            }
            break
        @unknown default:
            break
        }
    }
    
    //this function uses a snapshot to determine whether a location is relevant
    func handleDataChanges(snapshot: DataSnapshot){
        let location = snapshot.value as? [String: Any]
        print("Location \(location)")
        if let location = location{
            if(addedLocationIDs.contains(location["id"]! as! String)){
                return
            }
            
            //the session's id:
            let id = location["id"] as! String
            
            //if the finish time of the session is before the current time, get rid of it!
            let timeFinishString = location["timeFinishString"] as! String
            let formatter = DateFormatter()
            formatter.dateFormat = K.dateFormatString
            let timeFinishDate = formatter.date(from: timeFinishString)!
            if(timeFinishDate < Date()){
                deleteSession(sessionID: id)
            }
            
            let courseString = location["course"] as! String
            
            
            if(self.courses.contains(courseString)){
                let newLocation = Location(latitude: location["latitude"] as? Double ?? 0,
                                           longitude: location["longitude"] as? Double ?? 0,
                                           locationDescription: location["locationDescription"] as? String ?? "",
                                           locationSubdescription: location["locationSubdescription"] as? String ?? "",
                                           sessionGoal: location["sessionGoal"] as? String ?? "",
                                           courseString: courseString,
                                           colorHex: location["colorHex"] as? String ?? "ffff00",
                                           timeFinishString: location["timeFinishString"] as? String ?? "",
                                           id: id,
                                           creatorSafeEmail: location["creatorSafeEmail"] as? String ?? "", messages: location["messages"] as? [String] ?? [])
                self.colorDict[courseString] = location["colorHex"] as? String ?? "ffff00"
                self.addPin(location: newLocation)
                
                self.relevantLocations.append(newLocation)
                if(friendSafeEmails.contains(newLocation.creatorSafeEmail)){
                    self.friendsOnlyLocations.append(newLocation)
                }
                self.addedLocationIDs.append(id)
                
            }
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if(courses.count > 0){
            performSegue(withIdentifier: "toForm", sender: self)
        }else{
            let alert = UIAlertController(title: "No Courses Available", message: "You haven't selected any courses to create study sessions for. Go to the Courses tab to select courses.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func deleteSession(sessionID: String) -> Bool{
        //Get school from user defaults to use in Firebase path.
        guard let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String else {return false}
        
        //remove the session by sessionID from locations.
        ref.child(school).child("sessions").child(sessionID).removeValue { error, reference in
            if let error = error{
                print("ERROR: \(error.localizedDescription)")
            }
        }
        sessionsTableView.reloadData()
        return true
    }
    
    @IBAction func friendsSwitchValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("LOG: Friends' Groups selected")
            onlyFriendGroups = true
        }else{
            print("LOG: All Groups selected")
            onlyFriendGroups = false
        }
        sessionsTableView.reloadData()
    }
    
}

extension MapController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(locationManager: locationManager, status: status)
    }
}

extension MapController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation.title == "My Location"){
            return nil
        }
        let courseID = annotation.subtitle!
        print("Course ID: \(courseID)")
        print("annotation: \(annotation)")
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        if(courseID != nil){
            annotationView.markerTintColor = UIColor(colorDict[courseID!]!)
        }
        return annotationView
    }
}

//TableView Stuff from here on
extension MapController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell
        
        if(indexPath.row < relevantLocations.count){
            if onlyFriendGroups{
                let location = friendsOnlyLocations[indexPath.row]
                cell.setUpData(location: location)
            }else{
                let location = relevantLocations[indexPath.row]
                cell.setUpData(location: location)
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let chatAction = SwipeAction(style: .default, title: "Chat") { action, indexPath in
            let sessionCell = tableView.cellForRow(at: indexPath) as! SessionTableViewCell
            if let session = sessionCell.session{
                let chatViewController = ChatViewController()
                chatViewController.title = "\(session.courseString) Session"
                chatViewController.navigationItem.largeTitleDisplayMode = .never
                self.navigationController?.pushViewController(chatViewController, animated: true)
            }else{
                
            }
        }
        chatAction.backgroundColor = .link
        chatAction.image = UIImage(systemName: "message.fill")?.withTintColor(.white)
        return [chatAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onlyFriendGroups{
            return friendsOnlyLocations.count
        }else{
            return relevantLocations.count
        }
    }
    
    //Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let locationSelected = relevantLocations[indexPath.row]
//        let latitude = locationSelected.latitude
//        let longitude = locationSelected.longitude
//        centerViewToLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "TITLE"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MapController{
    
    
}


extension UIColor {
  
  convenience init(_ hex: String, alpha: CGFloat = 1.0) {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") { cString.removeFirst() }
    
    if cString.count != 6 {
      self.init("ff0000") // return red color for wrong hex input
      return
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }
}
