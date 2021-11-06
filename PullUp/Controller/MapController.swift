//
//  MapController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
import MapKit


class MapController: UIViewController{
    let annotations: [MKAnnotation] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.loc
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        
//        let libraryAnnotation = MKPointAnnotation()
//        libraryAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(42.389812), longitude: CLLocationDegrees(-72.528252))
//        libraryAnnotation.title = "Library"
//        libraryAnnotation.p
//        mapView.addAnnotation(libraryAnnotation)
        addNewPin()
    }
    
    func addNewPin(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(42.389812), longitude: CLLocationDegrees(-72.528252))
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
