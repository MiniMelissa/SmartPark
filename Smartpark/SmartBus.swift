//
//  Bus.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import MapKit

//used to make bus annotations on map
class SmartBus: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let imageName = "bus_green.png"
    let icon_size: Double = 35
    
    init(bus_number: String, coordinate: CLLocationCoordinate2D) {
        
        self.subtitle = "Bus #\(bus_number)"
        self.title = "Campus Shuttle"
        self.coordinate = coordinate
        //super.init()
       
    }
    
}

