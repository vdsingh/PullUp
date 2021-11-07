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

    
//    var courseDictionary: [String: Bool] = [:]
    var courses: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        sessionsTableView.dataSource = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
            
        ref.child("users").child(uid!).child("courses").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? [String: Bool]
//            print("Course Values: \(value)")
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
                if(self.courses.contains(courseString)){
                    print("Found a location with course \(courseString) which user is signed up for")
                    let newLocation = Location(latitude: actualLocation["latitude"] as? Double ?? 0, longitude: actualLocation["longitude"] as? Double ?? 0, locationDescription: actualLocation["locationDescription"] as? String ?? "", locationSubdescription: actualLocation["locationSubdescription"] as? String ?? "", courseString: courseString, colorHex: actualLocation["colorHex"] as? String ?? "ffff00")
                    self.addPin(location: newLocation)
                    self.relevantLocations.append(newLocation)
                }
            }
            self.sessionsTableView.reloadData()
        }
    }
    
    func addPin(location: Location){
        print("adding location \(location.locationDescription)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
        annotation.title = location.locationDescription
        annotation.subtitle = location.courseString
        mapView.addAnnotation(annotation)
    }
    
    func centerViewToUserLocation(center: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
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
                centerViewToUserLocation(center: center)
            }
            break
        @unknown default:
            break
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
extension MapController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        
        cell.textLabel?.text = relevantLocations[indexPath.row].courseString
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relevantLocations.count
    }
}
