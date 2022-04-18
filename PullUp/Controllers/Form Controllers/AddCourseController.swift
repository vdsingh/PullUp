//
//  AddCourseController.swift
//  PullUp
//
//  Created by Vikram Singh on 1/9/22.
//

import Foundation
import UIKit
import Firebase
class AddCourseController: UIViewController{
    var coursePrefixes: [String] = ["CS", "CICS", "INFO", "ACCOUNTG", "CHEM", "AEROSPAC", "AFROAM", "ANIMLSCI", "ANTHRO", "STOCKSCH", "ARCH", "ART-HIST", "ARTS-EXT", "ASTRON", "BIOCHEM", "BIOLOGY", "MICROBIO", "BCT", "FINANCE", "HT-MGT", "MANAGMNT", "OIM", "SCH-MGMT", "CE-ENGIN", "CLASSICS", "COMM-DIS", "COMM", "COMP-LIT", "SOCIOL", "ECON", "RES-ECON", "UWW", "EDUC", "ENGIN", "ENGLWRIT", "ENGLISH", "KIN", "FOOD-SCI", "FRENCHST", "GEOGRAPH", "GEOLOGY", "GEO-SCI", "GERMAN", "HISTORY", "HONORS", "JOURNAL", "LANDARCH", "LEGAL", "LINGUIST", "MARKETNG", "MATH", "MUSIC", "NATSCI", "NRC", "NURSING", "NUTRITN", "PHIL", "PHYSICS", "POLISCI", "PSYCH", "HPP", "PUBHLTH", "SOCBEHAV", "SPANISH", "STATISTC", "THEATER", "LLWIND"]
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var prefixPicker: UIPickerView!
    
    @IBOutlet var courseNumberTextFields: [UITextField]!
    
    var selectedPrefix: String!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        errorLabel.text = ""
        coursePrefixes.sort()
        selectedPrefix = coursePrefixes[0]
        
        prefixPicker.dataSource = self
        prefixPicker.delegate = self
        
    }
    @IBAction func addCoursePressed(_ sender: UIButton) {
        errorLabel.text = ""
        var courses: [String] = []
        
        //the course prefix that is selected in the picker.
        let coursePrefix = coursePrefixes[prefixPicker.selectedRow(inComponent: 0)]
        for textField in courseNumberTextFields {
            //this textfield is not filled out.
            if(textField.text == nil || textField.text == ""){
                continue
            }
            let text = textField.text!
            //course number is too long. Must be max 4 characters (ex: 197A)
            if(text.count > 4){
                errorLabel.text = "Course numbers cannot be longer than 4 characters."
                return
            }
            
            let courseName = coursePrefix + text
//            if(courseExists(courseName: courseName)){
//                print("Course EXISTS: \(courseName)")
//                errorLabel.text = "Course \(courseName) already exists."
//                return
//            }
            
            //the textField has passed all tests.
            courses.append(courseName)
        }
        //the user didn't fill out any course number textFields.
        if(courses.count == 0){
            errorLabel.text = "You must specify at least one course number."
            return
        }
        
        
        addCourses(courses: courses)
        self.dismiss(animated: true, completion: nil)
    }
    
    //checks whether the course already exists in the realtime database. If so, return true, if not, return false.
    func courseExists(courseName: String) -> Bool{
        var exists: Bool? = nil
        
        //observe changes
//        let observerHandle = ref.child("courses").child(courseName).observe(DataEventType.value, with: { snapshot in
//            print("closure call")
//            exists = snapshot.exists()
//        })
        
        ref.child("courses").child(courseName).observeSingleEvent(of: DataEventType.value) { snapshot in
            print("closure call")
            exists = snapshot.exists()
        }
        
        while(exists == nil){
            print("haven't received result.")
            sleep(1)
            continue
        }
//        ref.removeObserver(withHandle: observerHandle)
        return exists!
    }
    
    //add the courses to the firebase realtime database.
    func addCourses(courses: [String]){
        for course in courses{
            let randomHex: String = UIColor.generateRandomHexColor()
            ref.child("courses").child(course).setValue(["colorHex": randomHex, "title": course, "addedBy": Auth.auth().currentUser?.email ?? "developer"])
        }
    }
}

extension AddCourseController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coursePrefixes.count
    }
    
}

extension AddCourseController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coursePrefixes[row]
    }
}
