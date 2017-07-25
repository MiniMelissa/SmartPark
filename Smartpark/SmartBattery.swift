//
//  Battery.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation

class SmartBattery {
    
    var userid: String
    var timestamp: Int64
    var percentage: Int64
    
    init(userid: String, timestamp: Int64, percentage: Int64){
        self.userid = userid
        self.timestamp = timestamp
        self.percentage = percentage
    }
    
}
