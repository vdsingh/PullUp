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


class MapController: UIViewController{
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
//    var addedLocationIDs: [String] = []

    
//    var courseDictionary: [String: Bool] = [:]
    var courses: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        sessionsTableView.dataSource = self
        sessionsTableView.delegate = self
        locationManager.startUpdatingLocation()
        
        //register session cells
        sessionsTableView.register(UINib(nibName: "SessionTableViewCell", bundle: nil), forCellReuseIdentifier: "sessionCell")
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        relevantLocations = []
        courses = []

        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
            
        ref.child("users").child(uid!).child("courses").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? [String: Bool]
//            print("Course Values: \(value)")
            for key in value!.keys {
                if(value![key] == true){
                    self.courses.append(key)
                    print("added \(key) to courses")
                }
            }
        }) { error in
          print(error.localizedDescription)
        }

        ref.child("locations").observe(.childAdded) { snapshot in
            self.handleDataChanges(snapshot: snapshot)
            self.sessionsTableView.reloadData()
        }
//        ref.child("locations").observe(.childRemoved) { snapshot in
//            self.handleDataChanges(snapshot: snapshot)
//            self.sessionsTableView.reloadData()
//        }
        ref.child("users").child(uid!).child("courses").observe(.childAdded, with: { snapshot in
            self.handleDataChanges(snapshot: snapshot)
            self.sessionsTableView.reloadData()
        })
        ref.child("users").child(uid!).child("courses").observe(.childRemoved, with: { snapshot in
//            self.relevantLocations = []
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
//        for var i in 0..<relevantLocations.count  {
//            if(!courses.contains(relevantLocations[i].courseString)){
//                relevantLocations.remove(at: i)
//                i-=1
//            }
//        }
        let location = snapshot.value as? [String: Any]
        print("LOcation \(location)")
//            if(addedLocations.contains(location.keys))
        
        if let actualLocation = location{
            let courseString = actualLocation["course"] as! String
            let id = actualLocation["id"] as! String
            if(self.courses.contains(courseString)){ //&& !self.addedLocationIDs.contains(id)){
//                let id = UUID().uuidString
//                    print("Found a location with course \(courseString) which user is signed up for")
                let newLocation = Location(latitude: actualLocation["latitude"] as? Double ?? 0, longitude: actualLocation["longitude"] as? Double ?? 0, locationDescription: actualLocation["locationDescription"] as? String ?? "", locationSubdescription: actualLocation["locationSubdescription"] as? String ?? "", sessionGoal: actualLocation["sessionGoal"] as? String ?? "", courseString: courseString, colorHex: actualLocation["colorHex"] as? String ?? "ffff00", timeFinishString: actualLocation["timeFinishString"] as? String ?? "", id: id)
                self.addPin(location: newLocation)
                self.relevantLocations.append(newLocation)
//                self.addedLocationIDs.append(id)
            }
        }
    }
}

extension MapController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(locationManager: locationManager, status: status)

    }
}

extension MapController: MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let annotationView = MKPinAnnotationView()
//        annotationView.pinTintColor = .green
//        return annotationView
//    }
}

//TableView Stuff from here on
extension MapController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell
        
//        cell.textLabel?.text = relevantLocations[indexPath.row].courseString
        print("Relevant Locations: \(relevantLocations)")
        print("row: \(indexPath.row)")
        let location = relevantLocations[indexPath.row]
        cell.setUpDate(location: location)
//        cell.courseNameLabel.text = location.courseString
//        cell.pinImageView.tintColor = UIColor(hex: location.colorHex)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relevantLocations.count
    }
    
    //delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationSelected = relevantLocations[indexPath.row]
        let latitude = locationSelected.latitude
        let longitude = locationSelected.longitude
        
        centerViewToLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
//        mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
    }

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
