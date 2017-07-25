//
//  Gps.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation

class SmartGps {
    var userid: String
    var timestamp: Int64
    var latitude: Double
    var longitude: Double
    
    init(userid: String, timestamp: Int64, latitude: Double, longitude: Double){
        self.userid = userid
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }
}
