//
//  File.swift
//  Smartpark
//
//  Created by xumeng on 8/29/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation

class SmartMagnetometer{
    
    var userid: String
    var timestamp: Int64
    var x: Double
    var y: Double
    var z: Double
    
    init(userid: String, timestamp: Int64, x: Double, y: Double, z: Double){
        self.userid = userid
        self.timestamp = timestamp
        self.x = x
        self.y = y
        self.z = z
    }
    
}
