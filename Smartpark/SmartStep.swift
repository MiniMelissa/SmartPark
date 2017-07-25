//
//  Step.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation

class SmartStep {
    
    var userid: String
    var timestamp: Int64
    var count: Int64
    
    init(userid: String, timestamp: Int64, count: Int64){
        self.userid = userid
        self.timestamp = timestamp
        self.count = count
    }

}
