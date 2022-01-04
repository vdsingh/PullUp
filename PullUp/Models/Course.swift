//
//  Course.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit
//import RealmSwift
class Course{
    @objc dynamic var colorHex: String = "ffffff"
    @objc dynamic var title: String = ""
    
    init(title: String, colorHex: String){
        self.title = title
        self.colorHex = colorHex
    }
}
