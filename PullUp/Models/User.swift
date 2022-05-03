//
//  User.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
//import RealmSwift
class User{
    var courses: [Course]?
    
    var username: String
    var name: String
    var email: String
    
    var school: String
    
    var safeEmail: String {
        return email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
    
//    var profilePictureImage: UIImage{
//        StorageManager.downloadImage(profilePictureURL: profilePictureFileName)
//    }
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    var uid: String?
    
    //Courses can be nil because we don't always need this information (if we are looking up another user, their course information is not relevant for that process)
    init(username: String, name: String, email: String, school: String, courses: [Course]?, uid: String?){
        self.username = username
        self.name = name
        self.courses = courses
//        self.profilePictureKey = profilePictureKey
        self.uid = uid
        self.email = email
        self.school = school
    }
    
    static func createBasicSelf() -> User{
        let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String ?? ""
        let name = UserDefaults.standard.value(forKey: K.nameKey) as? String ?? ""
        let email = UserDefaults.standard.value(forKey: K.emailKey) as? String ?? ""
        let school = UserDefaults.standard.value(forKey: K.schoolKey) as? String ?? ""

        
        let selfUser = User(username: username, name: name, email: email, school: school, courses: nil, uid: nil)
        return selfUser
    }
    
    static func safeEmail(emailAddress: String) -> String{
        return emailAddress.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")

    }
    
    
    //allows us to compare this user to self user to see if this user is self user.
    func isSelf() -> Bool{
        return username == UserDefaults.standard.value(forKey: K.usernameKey) as? String ?? ""
    }
}
