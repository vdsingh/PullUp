//
//  AddSessionController.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit
import MapKit
class AddSessionController: UIViewController{
    var ref: DatabaseReference!
    var selectedCourseString: String = ""
    
    var courses: [String] = []
    var latitude: Double = 0
    var longitude: Double = 0

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var coursePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursePicker.dataSource = self
        coursePicker.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func addSessionClicked(_ sender: UIButton) {
        print("Add session clicked")
        
        //need locationManager to get current location (for annotation latitude and longitude)
        let locationManager: CLLocationManager!
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        var colorHex = "ffffff"
        ref.child("courses").child(selectedCourseString).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: String]
            colorHex = value!["colorHex"]!
        }) { error in
          print(error.localizedDescription)
        }
        
        //create new location
//        let newLocation = Location(latitude: latitude, longitude: longitude, locationDescription: descriptionTextField.text!, locationSubdescription: selectedCourseString, courseString: selectedCourseString, colorHex: colorHex)
//        self.dismiss(animated: true, completion: nil)
        self.ref.child("locations").child(UUID().uuidString).setValue(["colorHex": colorHex, "latitude": latitude, "longitude": longitude, "locationDescription": descriptionTextField.text!, "locationSubdescription": selectedCourseString, "course": selectedCourseString])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("called viewWillAppear")
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
            
        ref.child("users").child(uid!).child("courses").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: Bool]
            //convert the dictionary into an array of keys
            for key in value!.keys{
                if(value![key]!){
                    self.courses.append(key)
                }
            }
            self.selectedCourseString = self.courses[0]
            self.coursePicker.reloadAllComponents()
            
        }) { error in
          print(error.localizedDescription)
        }
    }
}

extension AddSessionController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let intIndex = row
//        let index = courseDictionary.index(courseDictionary.startIndex, offsetBy: intIndex)
        print("Selected Course = \(courses[row])")
        selectedCourseString = courses[row]
//        return courses[row]
    }
}

extension AddSessionController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let intIndex = row
//        let index = courseDictionary.index(courseDictionary.startIndex, offsetBy: intIndex)
//        print("selectedCourse is \(courseDictionary.keys[index])")
//        return courseDictionary.keys[index]
        return courses[row]
    }
}

extension AddSessionController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
    }
}
