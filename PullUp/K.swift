//
//  K.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit

class K{
    static var courses: [String: Course] = [
        "CS121": Course(title: "CS121", colorHex: "ff0000"),
        "CS187": Course(title: "CS187", colorHex: "ffa500"),
        "CS220": Course(title: "CS220", colorHex: "008000"),
        "CS230": Course(title: "CS230", colorHex: "0000ff"),
        "CS240": Course(title: "CS240", colorHex: "00ffff"),
        "CS250": Course(title: "CS250", colorHex: "800080"),
        "CS311": Course(title: "CS311", colorHex: "ffc0cb"),
        "CS345": Course(title: "CS345", colorHex: "ffff00"),
    ]
    
    //colors
    static let maroonColorHex = "881c1c"
    static let maroonColor = UIColor(maroonColorHex)
    
    //UserDefaults keys
    static let emailKey = "Email"
    static let usernameKey = "Username"
    static let schoolKey = "School"
    static let nameKey = "Name"
    
    //Segue IDs
    static let signUpToMainSegue = "signUpToMain"
    
    //Date Format Strings
    static let dateFormatString = "MM-dd-yyyy HH:mm"
}
