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
    var colorHex: String = "ffffff"
    var latitude: Double = 0
    var longitude: Double = 0

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sessionGoalTextField: UITextField!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var finishTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursePicker.dataSource = self
        coursePicker.delegate = self
        
        finishTimeDatePicker.date = Date() + (60*60)
        
        errorLabel.textColor = .red
        errorLabel.text = ""
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            self.ref.child("courses").child(self.selectedCourseString).observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? [String: Any] {
                    self.colorHex = value["colorHex"] as! String
                }else {
                    print("FATAL: value is nil when retrieving courses in AddSessionController")
                }
            }) { error in
              print(error.localizedDescription)
            }
    
            self.coursePicker.reloadAllComponents()
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    @IBAction func addSessionClicked(_ sender: UIButton) {
        errorLabel.text = ""
        print("Add session clicked")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("FATAL: user is not signed in when trying to add a session!")
            return
        }
        
        //if there are any missing fields/other errors in the form, display them in the error label.
        if(sessionGoalTextField.text == ""){
            errorLabel.text = "Please enter a description for what you're working on or studying for."
            return
        }
        
        if(descriptionTextField.text == ""){
            errorLabel.text = "Please enter a description for the location you're studying at."
            return
        }
        
        if(finishTimeDatePicker.date < Date()){
            errorLabel.text = "The session must end later than the current time."
            return
        }
        
        //need locationManager to get current location (for annotation latitude and longitude)
        let locationManager: CLLocationManager! = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled()){
//            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        let center = locationManager.location?.coordinate
        
        latitude = center!.latitude
        longitude = center!.longitude
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormatString
        let dateFromStr = dateFormatter.string(from: finishTimeDatePicker.date)
        print("Date from str: \(dateFromStr)")
        let id = UUID().uuidString
        
        self.ref.child("sessions").child(id).setValue(["colorHex": colorHex, "latitude": latitude, "longitude": longitude, "locationDescription": descriptionTextField.text!, "locationSubdescription": selectedCourseString, "course": selectedCourseString, "sessionGoal": sessionGoalTextField.text ?? "", "timeFinishString": dateFromStr, "id": id, "addedBy": Auth.auth().currentUser?.email ?? "anon"])
        
        //set the user's current session to the id of this session.
        self.ref.child("users").child(uid).child("currentSession").setValue(id)
        
        dismiss(animated: true, completion: nil)
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
        ref.child("courses").child(selectedCourseString).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: String]
            self.colorHex = value!["colorHex"]!
            print("ColorHex: \(self.colorHex)")
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    //Calls this function when the tap is recognized.
//    @objc func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
}

extension AddSessionController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
