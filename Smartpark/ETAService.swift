//
//  ETAService.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/7/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import MapKit


class ETAService {
    
    /*
     * To build a url to query ETA information you need the base url + service name + token
     */
    private let ETA_BASE_URL: String = "http://binghamtonupublic.etaspot.net/service.php?service="
    private let ETA_TOKEN: String = "&token=0110d56e0d4b777d95315b6c398f9b5a1a4870a9"
    private let ETA_GET_ROUTES_SERVICE: String = "get_routes"
    private let ETA_GET_STOPS_SERVICE: String = "get_stops"
    private let ETA_GET_STOP_ETAS_SERVICE: String = "get_stop_etas"
    private let ETA_GET_VEHICLES_SERVICE: String = "get_vehicles"
    private let ETA_GET_SCHEDULES_SERVICE: String = "get_schedules"
    private let ETA_GET_SERVICE_ANNOUNCEMENTS_SERVICE: String = "get_service_announcements"
    private let ETA_CAMPUS_SHUTTLE_ROUTE_ID: String = "&routeID=8"
    
    private let CAMPUS_SHUTTLES = ["747", "748", "762", "763"] //equipment IDs of campus shuttles in the fleet
    private var campus_shuttle_buses = [SmartBus]() //hold campus shuttles that are in service
    private var campus_shuttle_stops = [SmartStop]() //holds all the campus shuttle stops
    private let group = DispatchGroup()


    init(){
        
    }
    
    func setup(completionHandler: () -> Void){
        group.enter()
        self.eta_set_campus_shuttles()
        group.wait()
        completionHandler()
    }
    
    
    private func eta_set_vehicles(completionHandler: @escaping ([Dictionary<String, Any>]?, Error?) -> Void) {
        let url_string = ETA_BASE_URL + ETA_GET_VEHICLES_SERVICE + ETA_TOKEN
        let url = URL(string: url_string)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        var vehicles = [Dictionary<String, Any>]()
        if DEBUGHTTP {print("Send request")}
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                print("Error with ETA get vehicles request")
                completionHandler(nil, "Error with ETA get vehicles request" )
                return
            }
            guard let responseData = data else {
                print("No data from ETA get vehicles request")
                completionHandler(nil, "No data from ETA get vehicles request")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                    print("Error converting eta get vehicles data to json")
                    completionHandler(nil, "Error converting eta get vehicles data to json")
                    return
                }
                vehicles = json["get_vehicles"] as! [Dictionary<String, Any>]
                if DEBUGHTTP {print("Send completion handler")}
                completionHandler(vehicles, nil)
            } catch {
                print("Error converting eta get vehicles to json")
                completionHandler(nil, "Error converting eta get vehicles to json" )
                return
            }
        })
        task.resume()
        if DEBUGHTTP {print("Returning from eta_get_vehicles")}
    }
    
    func get_campus_shuttle_buses() -> [SmartBus] {
        return self.campus_shuttle_buses
    }
    
    //returns array of all campus shuttles in the fleet that are in service
    func eta_set_campus_shuttles() {
        eta_set_vehicles(completionHandler: { buses, error in
            print("attemping to print buses")
            guard let all_vehicles = buses else {
                print("Error getting campus shuttles")
                return
            }
            guard error == nil else {
                print("Error getting campus shuttles with error ")
                return
            }
            self.set_campus_shuttles_helper(all_vehicles: all_vehicles)
            self.group.leave()
        })
        
    }
    
    private func set_campus_shuttles_helper(all_vehicles: [Dictionary<String, Any>]){
        let all_campus_shuttles: [Dictionary<String, Any>] = all_vehicles.filter {self.CAMPUS_SHUTTLES.contains($0["equipmentID"] as! String)}
        let in_service_campus_shuttles = all_campus_shuttles.filter {$0["inService"] as! Int == 1}
        var cs_shuttles = [SmartBus]()
        for bus in in_service_campus_shuttles {
            let bus_num: String = bus["equipmentID"] as! String
            let lat: Double = bus["lat"] as! Double
            let long = bus["lng"] as! Double
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let new_bus = SmartBus(bus_number: bus_num, coordinate: coordinate)
            cs_shuttles.append(new_bus)
        }
        self.campus_shuttle_buses = cs_shuttles
        print("Returning from eta_get_campus_shuttles")
    }
    
    //returns an array of all campus shuttle bus stops
    func eta_get_campus_shuttle_stops() -> [SmartStop]? {
        if self.campus_shuttle_stops != nil && self.campus_shuttle_stops.count > 0 {return self.campus_shuttle_stops}
        let group = DispatchGroup()
        group.enter()
        let url_string = ETA_BASE_URL + ETA_GET_STOPS_SERVICE + ETA_CAMPUS_SHUTTLE_ROUTE_ID + ETA_TOKEN
        let url = URL(string: url_string)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        var bus_stops = [Dictionary<String, Any>]()
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                print("Error with ETA get stops request")
                print(error!)
                group.leave()
                return
            }
            guard let responseData = data else {
                print("No data from ETA get stops request")
                group.leave()
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                    print("Error converting eta get stops data to json")
                    group.leave()
                    return
                }
                bus_stops = json["get_stops"] as! [Dictionary<String, Any>]
                group.leave()
               
            } catch {
                print("Error converting eta get stops to json")
                group.leave()
                return
            }
        })
        task.resume()
        group.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(10))
        let filtered_stops = bus_stops.filter {$0["rid"] as! Int == 8} //8 is the cs id assigned by eta
        var cs_stops = [SmartStop]()
        for stop in filtered_stops {
            let stop_id = stop["id"] as! Int
            let stop_name = stop["name"] as! String
            let stop_lat = stop["lat"] as! CLLocationDegrees
            let stop_long = stop["lng"] as! CLLocationDegrees
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: stop_lat , longitude: stop_long)
            let new_stop = SmartStop(stop_id: stop_id, stop_name: stop_name, coordinate: coordinate)
            cs_stops.append(new_stop)
        }
        self.campus_shuttle_stops = cs_stops
        return self.campus_shuttle_stops

    }
    
    func eta_get_stop_etas() {
        
    }
    
    
}
