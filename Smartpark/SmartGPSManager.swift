//
//  SmartGPSManager.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/2/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import CoreLocation


class SmartGPSManager: NSObject, CLLocationManagerDelegate {

    let location_manager = CLLocationManager()

    static let gps_instance = SmartGPSManager()
    
    override private init(){
        super.init()
        self.configureLocationManager()
    }
    
    func startSmartGPSManager(){
        print("SmartGPSManager started")
    }
    
    private func configureLocationManager() -> Void {
        location_manager.requestAlwaysAuthorization()
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.allowsBackgroundLocationUpdates = true
        location_manager.pausesLocationUpdatesAutomatically = false
        location_manager.startUpdatingLocation()
    }
    
    func locationManager( _ location_manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        let timestamp = getDateinMilliseconds()
        _ = LocalDB.db_instance.insertGPS(cuserid: USER_ID, ctimestamp: timestamp, clatitude: lat, clongitude: long)
        if DEBUG {print("In GPSManager locationManager method")}
    }
    
    func stopGPSManagerUpdates(){
        location_manager.stopUpdatingLocation()
    }
    
    func startGPSManagerUpdates(){
        location_manager.startUpdatingLocation()
    }



}
