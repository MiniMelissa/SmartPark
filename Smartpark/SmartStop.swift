//
//  SmartStop.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/8/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import MapKit

class SmartStop: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let imageName = "bus_stop_blue.png"
    let icon_size: Double = 20
    let stop_id: Int?
    
    init(stop_id: Int, stop_name: String, coordinate: CLLocationCoordinate2D){
        self.stop_id = stop_id
        self.title = stop_name
        self.subtitle = ""
        self.coordinate = coordinate
        //super.init()
    }

    
}
