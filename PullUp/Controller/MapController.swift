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


class MapController: UIViewController{
//    var locations: [Location] = []
//                                 Location(latitude: 42.389812, longitude: -72.528252, locationDescription: "Library", course: K.courses["CS230"]!)
//    ]
//    let annotations: [MKAnnotation] = []
    
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
    let locationDistance: Double = 1000
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.loc
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()

        databaseHandle = ref.child("locations").observe(.childAdded) { snapshot in
            print("fetching locations.")
            //take the value from the snapshot and add it to courses
            let location = snapshot.value as? [String: Any]
            print("location \(location)")
            if let actualLocation = location{
//                print("Course: \(actualCourse)")
                self.addPin(location: Location(latitude: actualLocation["latitude"] as! Double, longitude: actualLocation["longitude"] as! Double, locationDescription: actualLocation["locationDescription"] as! String, locationSubdescription: actualLocation["locationSubdescription"] as! String))

            }
        }
        
//        addPin(location: Location)
    }
    
    func addPin(location: Location){
//        for location in locations {
        print("adding location \(location.locationDescription)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
        annotation.title = location.locationDescription
        annotation.subtitle = location.locationSubdescription
        mapView.addAnnotation(annotation)
//        }
        
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
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last{
//            let center = location.coordinate
//            centerViewToUserLocation(center: center)
//        }
//    }
}

extension MapController: MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////        let annotationView = MKPinAnnotationView()
////        annotationView.pinTintColor = .green
////        return annotationView
//    }
}
