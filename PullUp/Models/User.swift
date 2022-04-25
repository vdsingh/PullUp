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
    var profilePictureKey: String
    var uid: String
    
    //Courses can be nil because we don't always need this information (if we are looking up another user, their course information is not relevant for that process)
    init(username: String, name: String, courses: [Course]?, profilePictureKey: String, uid: String){
        self.username = username
        self.name = name
        self.courses = courses
        self.profilePictureKey = profilePictureKey
        self.uid = uid
    }
}
