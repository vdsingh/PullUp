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
    var courses: [Course] = []
    var tag: String
    var name: String
    var profilePicture: UIImage?
    
    init(tag: String, name: String, courses: [Course]){
        self.tag = tag
        self.name = name
        self.courses = courses
    }
}
