//
//  Wifi.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation

class SmartWifi {
    
    var userid: String
    var timestamp: Int64
    var state: Int64
    
    init(userid: String, timestamp: Int64, state: Int64){
        self.userid = userid
        self.timestamp = timestamp
        self.state = state
    }
    
}
