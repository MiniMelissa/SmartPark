//
//  LocalDB.swift
//  termination_project
//
//  Created by Timothy Redband on 3/26/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import SQLite

class LocalDB{
    
    
    private let db: Connection?
    static let db_instance = LocalDB()
    
    var num_accel_rows_posted = 0
    var num_gyro_rows_posted = 0
    var num_battery_rows_posted = 0
    var num_wifi_rows_posted = 0
    var num_step_rows_posted = 0
    var num_motionstate_rows_posted = 0
    var num_gps_rows_posted = 0
   
    //Accelerometer Table
    private let accelTable = Table("Accelerometer")
    private let accel_id = Expression<Int64>("Id")
    private let accel_userId = Expression<String>("UserID")
    private let accel_timestamp = Expression<Int64>("Timestamp")
    private let accel_x = Expression<Double>("X")
    private let accel_y = Expression<Double>("Y")
    private let accel_z = Expression<Double>("Z")
    
    //Gyroscope Table
    private let gyroTable = Table("Gyroscope")
    private let gyro_id = Expression<Int64>("Id")
    private let gyro_userId = Expression<String>("UserID")
    private let gyro_timestamp = Expression<Int64>("Timestamp")
    private let gyro_x = Expression<Double>("X")
    private let gyro_y = Expression<Double>("Y")
    private let gyro_z = Expression<Double>("Z")
    
    //Step Table
    private let stepTable = Table("Step")
    private let step_id = Expression<Int64>("Id")
    private let step_userId = Expression<String>("UserID")
    private let step_timestamp = Expression<Int64>("Timestamp")
    private let step_count = Expression<Int64>("Count")
    
    //Wifi Table
    private let wifiTable = Table("WiFi")
    private let wifi_id = Expression<Int64>("Id")
    private let wifi_userId = Expression<String>("UserID")
    private let wifi_timestamp = Expression<Int64>("Timestamp")
    private let wifi_state = Expression<Int64>("State")
    
    //MotionState Table
    private let motionStateTable = Table("MotionState")
    private let motionState_id = Expression<Int64>("Id")
    private let motionState_userId = Expression<String>("UserID")
    private let motionState_timestamp = Expression<Int64>("Timestamp")
    private let motionState_state = Expression<Int64>("State")
    
    //GPS Table
    private let gpsTable = Table("Gps")
    private let gps_id = Expression<Int64>("Id")
    private let gps_userId = Expression<String>("UserID")
    private let gps_timestamp = Expression<Int64>("Timestamp")
    private let gps_latitude = Expression<Double>("Latitude")
    private let gps_longitude = Expression<Double>("Longitude")
    
    //Battery Table
    private let batteryTable = Table("Battery")
    private let battery_id = Expression<Int64>("Id")
    private let battery_userId = Expression<String>("UserID")
    private let battery_timestamp = Expression<Int64>("Timestamp")
    private let battery_percentage = Expression<Int64>("Percentage")

    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/LocalDB3.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTables()
        
    }
    
    private func createTables(){
        createAccelerometerTable()
        createGyroTable()
        createStepTable()
        createWiFiTable()
        createMotionStateTable()
        createGpsTable()
        createBatteryTable()
    }
    
    private func createAccelerometerTable() {
        do {
            try db!.run(accelTable.create(ifNotExists: true) { table in
                table.column(accel_id, primaryKey: .autoincrement)
                table.column(accel_userId)
                table.column(accel_timestamp)
                table.column(accel_x)
                table.column(accel_y)
                table.column(accel_z)
            })
        } catch {
            print("Unable to create Accelerometer table")
        }
    }
    
    private func createGyroTable() {
        do {
            try db!.run(gyroTable.create(ifNotExists: true) { table in
                table.column(gyro_id, primaryKey: .autoincrement)
                table.column(gyro_userId)
                table.column(gyro_timestamp)
                table.column(gyro_x)
                table.column(gyro_y)
                table.column(gyro_z)
            })
        } catch {
            print("Unable to create Gyroscope table")
        }
    }
    
    private func createStepTable() {
        do {
            try db!.run(stepTable.create(ifNotExists: true) { table in
                table.column(step_id, primaryKey: .autoincrement)
                table.column(step_userId)
                table.column(step_timestamp)
                table.column(step_count)
            })
        } catch {
            print("Unable to create Step table")
        }
    }
    
    private func createWiFiTable() {
        do {
            try db!.run(wifiTable.create(ifNotExists: true) { table in
                table.column(wifi_id, primaryKey: .autoincrement)
                table.column(wifi_userId)
                table.column(wifi_timestamp)
                table.column(wifi_state)
            })
        } catch {
            print("Unable to create WiFi table")
        }
    }
    
    private func createMotionStateTable() {
        do {
            try db!.run(motionStateTable.create(ifNotExists: true) { table in
                table.column(motionState_id, primaryKey: .autoincrement)
                table.column(motionState_userId)
                table.column(motionState_timestamp)
                table.column(motionState_state)
            })
        } catch {
            print("Unable to create Wifi table")
        }
    }
    
    private func createGpsTable() {
        do {
            try db!.run(gpsTable.create(ifNotExists: true) { table in
                table.column(gps_id, primaryKey: .autoincrement)
                table.column(gps_userId)
                table.column(gps_timestamp)
                table.column(gps_latitude)
                table.column(gps_longitude)
            })
        } catch {
            print("Unable to create GPS table")
        }
    }
    
    private func createBatteryTable() {
        do {
            try db!.run(batteryTable.create(ifNotExists: true) { table in
                table.column(battery_id, primaryKey: .autoincrement)
                table.column(battery_userId)
                table.column(battery_timestamp)
                table.column(battery_percentage)
            })
        } catch {
            print("Unable to create Battery table")
        }
    }
    
    func insertAccelerometer(cuserid: String, ctimestamp: Int64, cx: Double, cy: Double, cz: Double) -> Int64?{
        do {
            let insert = accelTable.insert(accel_userId <- cuserid, accel_timestamp <- ctimestamp, accel_x <- cx, accel_y <- cy, accel_z <- cz)
            let id = try db!.run(insert)
            return id
        } catch{
            print("Accelerometer table insert failed")
            return -1
        }
    }
    
    func insertGyroscope(cuserid: String, ctimestamp: Int64, cx: Double, cy: Double, cz: Double) -> Int64? {
        do {
            let insert = gyroTable.insert(gyro_userId <- cuserid, gyro_timestamp <- ctimestamp, gyro_x <- cx, gyro_y <- cy, gyro_z <- cz)
            let id = try db!.run(insert)
            return id
            
        } catch{
            print("Gyro table insert failed")
            return -1
        }
    }
    
    func insertStep(cuserid: String, ctimestamp: Int64, ccount: Int64) -> Int64?{
        do {
            let insert = stepTable.insert(step_userId <- cuserid, step_timestamp <- ctimestamp, step_count <- ccount)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Step table insert failed")
            return -1
        }
    }
    
    func insertWifi(cuserid: String, ctimestamp: Int64, cstate: Int64) -> Int64? {
        do {
            let insert = wifiTable.insert(wifi_userId <- cuserid, wifi_timestamp <- ctimestamp, wifi_state <- cstate)
            let id = try db!.run(insert)
            return id
        } catch{
            print("WiFi table insert failed")
            return -1

        }
    }
    
    func insertMotionState(cuserid: String, ctimestamp: Int64, cstate: Int64) -> Int64?{
        do {
            let insert = motionStateTable.insert(motionState_userId <- cuserid, motionState_timestamp <- ctimestamp, motionState_state <- cstate)
            let id = try db!.run(insert)
            return id
        } catch{
            print("MotionState table insert failed")
            return -1
        }
    }
    
    func insertGPS(cuserid: String, ctimestamp: Int64, clatitude: Double, clongitude: Double) -> Int64?{
        do {
            let insert = gpsTable.insert(gps_userId <- cuserid, gps_timestamp <- ctimestamp, gps_latitude <- clatitude, gps_longitude <- clongitude)
            let id = try db!.run(insert)
            return id
        } catch{
            print("GPS table insert failed")
            return -1
        }
    }
    
    func insertBattery(cuserid: String, ctimestamp: Int64, cpercentage: Int64) -> Int64? {
        do {
            let insert = batteryTable.insert(battery_userId <- cuserid, battery_timestamp <- ctimestamp, battery_percentage <- cpercentage)
            let id = try db!.run(insert)
            return id
        } catch{
            print("Battery table insert failed")
            return -1
        }
    }
    
    /***************************************************************************************************
     Accelerometer JSON methods
    ****************************************************************************************************/
    
    //returns Rows of Accelerometer Data
    //called by accel_rows_to_json only
    private func getAccelerometer(num_rows: Int) -> [Row] {
        let query = accelTable.limit(num_rows).order(accel_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by accel_rows_to_json only
    private func accel_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var accel_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(accel_userId)),
                "Timestamp": NSNumber(value: elem.get(accel_timestamp)),
                "X": NSNumber(value: elem.get(accel_x)),
                "Y": NSNumber(value: elem.get(accel_y)),
                "Z": NSNumber(value: elem.get(accel_z))
            ]
            accel_dict.append(entry)
        }
        //print(accel_dict)
        return accel_dict
    }
    
    func accel_rows_to_json() -> Data {
        let row = getAccelerometer(num_rows: NUM_ROWS_FOR_QUERY)
        let accel_dict = accel_row_to_dictionary(row: row)
        var accel_json: Data?
        do {
            accel_json = try JSONSerialization.data(withJSONObject: accel_dict, options: .prettyPrinted)
            //let string = NSString(data: accel_json, encoding: String.Encoding.utf8.rawValue)
            //print(string)
        } catch{
            print("JSON went wrong")
        }
        num_accel_rows_posted = row.count
        if DEBUG {
            print("Accel rows posted = \(num_accel_rows_posted)")
        }
        return accel_json!
    }
    
    
    /****************************************************************************************************
     Gyroscope JSON methods
     ****************************************************************************************************/
    
    //called by gyro_rows_to_json only
    private func getGyroscope(num_rows: Int) -> [Row] {
        let query = gyroTable.limit(num_rows).order(gyro_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by gyro_rows_to_json only
    private func gyro_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var gyro_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(gyro_userId)),
                "Timestamp": NSNumber(value: elem.get(gyro_timestamp)),
                "X": NSNumber(value: elem.get(gyro_x)),
                "Y": NSNumber(value: elem.get(gyro_y)),
                "Z": NSNumber(value: elem.get(gyro_z))
            ]
            gyro_dict.append(entry)
        }
        return gyro_dict
    }
    
    func gyro_rows_to_json() -> Data {
        let row = getGyroscope(num_rows: NUM_ROWS_FOR_QUERY)
        let gyro_dict = gyro_row_to_dictionary(row: row)
        var gyro_json: Data?
        do {
            gyro_json = try JSONSerialization.data(withJSONObject: gyro_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_gyro_rows_posted = row.count
        if DEBUG {
            print("Gyro rows posted = \(num_gyro_rows_posted)")
        }
        return gyro_json!
    }
    
    
    /****************************************************************************************************
     GPS JSON methods
     ****************************************************************************************************/
    
    //called by gps_rows_to_json only
    private func getGps(num_rows: Int) -> [Row] {
        let query = gpsTable.limit(num_rows).order(gps_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by gps_rows_to_json only
    private func gps_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var gps_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(gps_userId)),
                "Timestamp": NSNumber(value: elem.get(gps_timestamp)),
                "Latitude": NSNumber(value: elem.get(gps_latitude)),
                "Longitude": NSNumber(value: elem.get(gps_longitude))
            ]
            gps_dict.append(entry)
        }
        return gps_dict
    }
    
    func gps_rows_to_json() -> Data {
        let row = getGps(num_rows: NUM_ROWS_FOR_QUERY)
        let gps_dict = gps_row_to_dictionary(row: row)
        var gps_json: Data?
        do {
            gps_json = try JSONSerialization.data(withJSONObject: gps_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_gps_rows_posted = row.count
        if DEBUG {
            print("GPS rows posted = \(num_gps_rows_posted)")
        }
        return gps_json!
    }
    
    /****************************************************************************************************
     Motionstate JSON methods
     ****************************************************************************************************/

    //called by motionState_rows_to_json only
    private func getMotionState(num_rows: Int) -> [Row] {
        let query = motionStateTable.limit(num_rows).order(motionState_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by motionState_rows_to_json only
    private func motionState_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var motionState_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(motionState_userId)),
                "Timestamp": NSNumber(value: elem.get(motionState_timestamp)),
                "State": NSNumber(value: elem.get(motionState_state)),
            ]
            motionState_dict.append(entry)
        }
        return motionState_dict
    }
    
    func motionState_rows_to_json() -> Data {
        let row = getMotionState(num_rows: NUM_ROWS_FOR_QUERY)
        let motionState_dict = motionState_row_to_dictionary(row: row)
        var motionState_json: Data?
        do {
            motionState_json = try JSONSerialization.data(withJSONObject: motionState_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_motionstate_rows_posted = row.count
        return motionState_json!
    }

    
    /****************************************************************************************************
     Wifi JSON methods
     ****************************************************************************************************/
    
    //called by wifi_rows_to_json only
    private func getWifi(num_rows: Int) -> [Row] {
        let query = wifiTable.limit(num_rows).order(wifi_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by wifi_rows_to_json only
    private func wifi_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var wifi_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(wifi_userId)),
                "Timestamp": NSNumber(value: elem.get(wifi_timestamp)),
                "State": NSNumber(value: elem.get(wifi_state)),
                ]
            wifi_dict.append(entry)
        }
        return wifi_dict
    }
    
    func wifi_rows_to_json() -> Data {
        let row = getWifi(num_rows: NUM_ROWS_FOR_QUERY)
        let wifi_dict = wifi_row_to_dictionary(row: row)
        var wifi_json: Data?
        do {
            wifi_json = try JSONSerialization.data(withJSONObject: wifi_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_wifi_rows_posted = row.count
        return wifi_json!
    }
    
    /****************************************************************************************************
     Battery JSON methods
     ****************************************************************************************************/
    
    //called by battery_rows_to_json only
    private func getBattery(num_rows: Int) -> [Row] {
        let query = batteryTable.limit(num_rows).order(battery_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by battery_rows_to_json only
    private func battery_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var battery_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(battery_userId)),
                "Timestamp": NSNumber(value: elem.get(battery_timestamp)),
                "Percentage": NSNumber(value: elem.get(battery_percentage)),
                ]
            battery_dict.append(entry)
        }
        return battery_dict
    }
    
    func battery_rows_to_json() -> Data {
        let row = getBattery(num_rows: NUM_ROWS_FOR_QUERY)
        let battery_dict = battery_row_to_dictionary(row: row)
        var battery_json: Data?
        do {
            battery_json = try JSONSerialization.data(withJSONObject: battery_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_battery_rows_posted = row.count
        return battery_json!
    }
    
    /****************************************************************************************************
     Step JSON methods
     ****************************************************************************************************/
    
    //called by step_rows_to_json only
    private func getStep(num_rows: Int) -> [Row] {
        let query = stepTable.limit(num_rows).order(step_id.asc)
        var row = [Row]()
        do {
            row = Array(try db!.prepare(query))
        } catch {
            print("none")
        }
        return row
    }
    
    //called by step_rows_to_json only
    private func step_row_to_dictionary(row: [Row]) -> [Dictionary<String, AnyObject>] {
        var step_dict: [Dictionary<String, AnyObject>] = []
        for elem in row{
            let entry = [
                "UserID": NSString(string: elem.get(step_userId)),
                "Timestamp": NSNumber(value: elem.get(step_timestamp)),
                "Count": NSNumber(value: elem.get(step_count)),
                ]
            step_dict.append(entry)
        }
        return step_dict
    }
    
    func step_rows_to_json() -> Data {
        let row = getStep(num_rows: NUM_ROWS_FOR_QUERY)
        
        let step_dict = step_row_to_dictionary(row: row)
        var step_json: Data?
        do {
            step_json = try JSONSerialization.data(withJSONObject: step_dict, options: .prettyPrinted)
        } catch{
            print("JSON went wrong")
        }
        num_step_rows_posted = row.count
        return step_json!
    }
    
    private func process_post_return(url_type: Int, response: String){
        var upload_success: Bool = false
        if response == "COMPLETE" {
            upload_success = true
        }
        switch (url_type){
            case URL_TYPE.ACCEL:
                if upload_success {delete_rows_accel()}
                if DEBUG {print("Signal accel")}
                accel_sem.signal()
                break
            case URL_TYPE.GYRO:
                if upload_success {delete_rows_gyro()}
                if DEBUG {print("Signal gyro")}
                gyro_sem.signal()
                break
            case URL_TYPE.GPS:
                if upload_success {delete_rows_gps()}
                if DEBUG {print("Signal gps")}
                gps_sem.signal()
                break
            case URL_TYPE.BATTERY:
                if upload_success {delete_rows_battery()}
                if DEBUG {print("Signal battery")}
                battery_sem.signal()
                break
            case URL_TYPE.STEP:
                if upload_success {delete_rows_step()}
                if DEBUG {print("Signal step")}
                step_sem.signal()
                break
            case URL_TYPE.WIFI:
                if upload_success {delete_rows_wifi()}
                if DEBUG {print("Signal wifi")}
                wifi_sem.signal()
                break
            case URL_TYPE.MOTIONSTATE:
                if upload_success {delete_rows_motionstate()}
                if DEBUG {print("Signal motionstate")}
                motionstate_sem.signal()
                break
            default:
                break
        }
    }
    
    
    /*Method to be called to POST data to CS server machine. Takes in a Data object as an argument that holds valid JSON and URL to send to that is defined in Globals.swift*/
    func post_data(post_data: Data, url_p: String, url_type: Int){
        
        let data_to_post = post_data
        let url = URL(string: url_p)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = data_to_post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            var responseString = String(data: data, encoding: .utf8)
            if responseString != nil {
                //if DEBUG {print("Entered code block for response string")}
                self.process_post_return(url_type: url_type, response: responseString!)
            } else {
                print("Response string was unexpectedly nil")
                responseString = "No response"
                self.process_post_return(url_type: url_type, response: responseString!)
            }
            print("responseString = \(responseString)")
            
        })
        task.resume()
    }
    
    
    func delete_rows_accel() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(accelTable.count)
            print("Accel old count is \(count)")
            if count != 0 {
                min = try db!.scalar(accelTable.select(accel_id.min))!
            } else {
                return
            }
        } catch {
            print("error")
        }
        
        let new_min_row = min + num_accel_rows_posted
        if DEBUG {print("Accel min = \(min) and accel new_min_row = \(new_min_row)")}
        let query = accelTable.filter(accel_id < new_min_row)
        do {
            try db!.run(query.delete())
            var count = try db!.scalar(gyroTable.count)
            print("Accel new count is \(count)")
        } catch {
            print("error deleting accel. Error=\(error)")
        }
    }
    
    func delete_rows_gyro() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(gyroTable.count)
//            if DEBUG {
//                print("Old count gyro = \(count)")
//            }
            if count != 0 {
                min = try db!.scalar(gyroTable.select(gyro_id.min))!
//                if DEBUG {
//                    print("Gyro min row id = \(min)")
//                }
            } else {
                return
            }
        } catch {
            print("error")
        }
        let new_min_row = min + num_gyro_rows_posted
//        if DEBUG {
//            print("Gyro new min row id = \(new_min_row)")
//        }
        let query = gyroTable.filter(gyro_id < new_min_row)
        do {
            try db!.run(query.delete())
            _ = try db!.scalar(gyroTable.count)
//            if DEBUG {
//                print("New count gyro = \(count)")
//            }

        } catch {
            print("error deleting gyro. Error=\(error)")
        }
    }
    
    func delete_rows_battery() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(batteryTable.count)
            if count != 0 {
                min = try db!.scalar(batteryTable.select(battery_id.min))!
            } else {
                return
            }
        } catch {
            print("error")
        }
        let new_min_row = min + num_battery_rows_posted
        let query = batteryTable.filter(battery_id < new_min_row)
        do {
            try db!.run(query.delete())
        } catch {
            print("error deleting battery. Error=\(error)")
        }
    }
    
    func delete_rows_wifi() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(wifiTable.count)
//            if DEBUG {
//                print("Old count wifi = \(count)")
//            }
            if count != 0 {
                min = try db!.scalar(wifiTable.select(wifi_id.min))!
            } else {
                return
            }
        } catch {
            print("error")
        }
        let new_min_row = min + num_wifi_rows_posted
        let query = wifiTable.filter(wifi_id < new_min_row)
        do {
            try db!.run(query.delete())
            _ = try db!.scalar(wifiTable.count)
//            if DEBUG {
//                print("New count wifi = \(count)")
//            }
        } catch {
            print("error deleting wifi. Error=\(error)")
        }
    }
    
    func delete_rows_motionstate() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(motionStateTable.count)
//            if DEBUG {
//                print("Old count motionstate = \(count)")
//            }
            if count != 0 {
                min = try db!.scalar(motionStateTable.select(motionState_id.min))!
            } else {
                return
            }
        } catch {
            print("error")
        }

        let new_min_row = min + num_motionstate_rows_posted
        let query = motionStateTable.filter(motionState_id < new_min_row)
        do {
            try db!.run(query.delete())
            _ = try db!.scalar(motionStateTable.count)
//            if DEBUG {
//                print("New count motionstate = \(count)")
//            }
        } catch {
            print("error deleting motionstate. Error=\(error)")
        }
    }
    
    func delete_rows_gps() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(gpsTable.count)
//            if DEBUG {
//                print("Old count gps = \(count)")
//            }
            if count != 0 {
                min = try db!.scalar(gpsTable.select(gps_id.min))!
//                if DEBUG {
//                    print("Gps min row id = \(min)")
//                }
            } else {
                return
            }
        } catch {
            print("error")
        }

        let new_min_row = min + num_gps_rows_posted
//        if  DEBUG {
//            print("Gps new min row id = \(new_min_row)")
//        }
        let query = gpsTable.filter(gps_id < new_min_row)
        do {
            try db!.run(query.delete())
            _ = try db!.scalar(gpsTable.count)
//            if DEBUG {
//                print("New count gps = \(count)")
//            }
        } catch {
            print("error deleting gps. Error=\(error)")
        }
    }
    
    func delete_rows_step() {
        var min: Int64 = -1
        do{
            let count = try db!.scalar(stepTable.count)
//            if DEBUG {
//                print("Old count step = \(count)")
//            }
            if count != 0 {
                min = try db!.scalar(stepTable.select(step_id.min))!
            } else {
                return
            }
        } catch {
            print("error")
        }
        let new_min_row = min + num_step_rows_posted
        let query = stepTable.filter(step_id < new_min_row)
        do {
            try db!.run(query.delete())
            _ = try db!.scalar(stepTable.count)
//            if DEBUG {
//                print("New count step = \(count)")
//            }

        } catch {
            print("error deleting step. Error=\(error)")
        }
    }
}
