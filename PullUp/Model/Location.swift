//
//  Location.swift
//  PullUp
//
//  Created by Vikram Singh on 11/6/21.
//

import Foundation
import UIKit

class Location{
    var latitude: Double
    var longitude: Double
    
    var locationDescription: String
    var locationSubdescription: String
    
    var colorHex: String
    var courseString: String
    
    init(latitude: Double, longitude: Double, locationDescription: String, locationSubdescription: String, courseString: String, colorHex: String){
        self.latitude = latitude
        self.longitude = longitude
        self.locationDescription = locationDescription
        self.locationSubdescription = locationSubdescription
        self.courseString = courseString
        self.colorHex = colorHex
//        self.course = course
    }
}
