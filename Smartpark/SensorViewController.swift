//
//  SensorViewController.swift
//  termination_project
//
//  Created by Timothy Redband on 2/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SensorViewController: UIViewController {
    
    let reach = Reachability()!
        
    //let pedometer = CMPedometer()
    
    var batteryLevel: Int64 = 0
    
    var battery_timer = Timer()
    var wifi_timer = Timer()
    
    static var location_switch_is_on: Bool = true
    static var gyro_switch_is_on: Bool = true
    static var accel_switch_is_on: Bool = true
    
    
    func schedule_battery_timer() -> Void {
        battery_timer = Timer.scheduledTimer(timeInterval: BATTERY_TIMER_INTERVAL, target: self, selector: #selector(self.log_battery_level), userInfo: nil, repeats: true)
    }
    
    func schedule_wifi_timer() -> Void{
        wifi_timer = Timer.scheduledTimer(timeInterval: WIFI_TIMER_INTERVAL, target: self, selector: #selector(self.log_wifi_status), userInfo: nil, repeats: true)
    }
    
    func log_battery_level() -> Void {
        let timestamp = getDateinMilliseconds()
        let battery_level = getBatteryLevel()
        _ = LocalDB.db_instance.insertBattery(cuserid: USER_ID, ctimestamp: timestamp, cpercentage: battery_level)
        //print("\(id) from battery")
    }
    
    func log_wifi_status() -> Void {
        let timestamp = getDateinMilliseconds()
        var state: Int64 = 0
        if reach.isReachableViaWiFi {
            state = 1
        }
        _ = LocalDB.db_instance.insertWifi(cuserid: USER_ID, ctimestamp: timestamp, cstate: state)
        //print("\(id) from wifi")
    }
    
    func do_post_data(){
        if DEBUG {print("In do_post_data")}
       
        if reach.isReachableViaWiFi {
            if DEBUGPOST {print("accel lock")}
            accel_sem.wait()
            if DEBUGPOST {print("Accel execute")}
            let accel_data = LocalDB.db_instance.accel_rows_to_json()
            LocalDB.db_instance.post_data(post_data: accel_data, url_p: ACCELEROMETER_URL, url_type: URL_TYPE.ACCEL)
            
            if DEBUGPOST {print("gyro lock")}
            gyro_sem.wait()
            if DEBUGPOST {print("gyro execute")}
            let gyro_data = LocalDB.db_instance.gyro_rows_to_json()
            LocalDB.db_instance.post_data(post_data: gyro_data, url_p: GYROSCOPE_URL, url_type: URL_TYPE.GYRO)
            
            if DEBUGPOST {print("battery lock")}
            battery_sem.wait()
            if DEBUGPOST {print("battery execuet")}
            let battery_data = LocalDB.db_instance.battery_rows_to_json()
            LocalDB.db_instance.post_data(post_data: battery_data, url_p: BATTERY_URL, url_type: URL_TYPE.BATTERY)
            
            if DEBUGPOST {print("wifi lock")}
            wifi_sem.wait()
            if DEBUGPOST {print("wifi execute")}
            let wifi_data = LocalDB.db_instance.wifi_rows_to_json()
            LocalDB.db_instance.post_data(post_data: wifi_data, url_p: WIFI_URL, url_type: URL_TYPE.WIFI)
            
            if DEBUGPOST {print("motionstate lock")}
            motionstate_sem.wait()
            if DEBUGPOST {print("motionstate execute")}
            let motionstate_data = LocalDB.db_instance.motionState_rows_to_json()
            LocalDB.db_instance.post_data(post_data: motionstate_data, url_p: MOTIONSTATE_URL, url_type: URL_TYPE.MOTIONSTATE)
            
            if DEBUGPOST {print("gps lock")}
            gps_sem.wait()
            if DEBUGPOST {print("gps execute")}
            let gps_data = LocalDB.db_instance.gps_rows_to_json()
            LocalDB.db_instance.post_data(post_data: gps_data, url_p: GPS_URL, url_type: URL_TYPE.GPS)
        }
    }
    

    
    func configurePedometer() -> Void {
        //let midnight_of_current_day: Date = get_midnight_of_current_day()
        
        //TODO
        
        /*
        pedometer.queryPedometerData(from: midnight_of_current_day, to: Date()) { (data, error) in
            if let pedoData = data {
                //TODO
            }
        }
 */
    }
    
    @IBOutlet weak var upload_button: UIButton!
    @IBAction func Upload_Data(_ sender: Any) {
        DispatchQueue.global(qos: .background).async {
            // Background Thread
            print("new upload thread")
            self.do_post_data()
        }
    }
    
    @IBAction func Select_Rate(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            SmartMotionSensorsManager.motion_sensors_instance.updateSamplingRates(new_rate: LOW_SAMPLING_RATE)
            print("low sampling rate selected")
        case 1:
            SmartMotionSensorsManager.motion_sensors_instance.updateSamplingRates(new_rate: MEDIUM_SAMPLING_RATE)
            print("medium sampling rate selected")
        case 2:
            SmartMotionSensorsManager.motion_sensors_instance.updateSamplingRates(new_rate: HIGH_SAMPLING_RATE)
            print("high sampling rate selected")
        default:
            print("Improper index when trying to set sampling rate")
            break;
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func getBatteryLevel() -> Int64 {
        let level = Int64(UIDevice.current.batteryLevel * 100)
        return level
    }
    
    @IBOutlet weak var accel_switch: UISwitch!
    @IBAction func toggle_accel_sensor(_ sender: Any) {
        if accel_switch.isOn {
            SensorViewController.accel_switch_is_on = true
            SmartMotionSensorsManager.motion_sensors_instance.set_accel_sensor(set: TURN_ON)
            if DEBUG{ print("accel switch = \(accel_switch.isOn)")}
        } else {
            SensorViewController.accel_switch_is_on = false
            SmartMotionSensorsManager.motion_sensors_instance.set_accel_sensor(set: TURN_OFF)
            if DEBUG{ print("accel switch = \(accel_switch.isOn)")}
        }
    }
    
    @IBOutlet weak var gyro_switch: UISwitch!
    @IBAction func toggle_gyro_sensor(_ sender: Any) {
        if gyro_switch.isOn{
            SensorViewController.gyro_switch_is_on = true
            SmartMotionSensorsManager.motion_sensors_instance.set_gyro_sensor(set: TURN_ON)
            if DEBUG{ print("gyro switch = \(gyro_switch.isOn)")}
        } else {
            SensorViewController.gyro_switch_is_on = false
            SmartMotionSensorsManager.motion_sensors_instance.set_gyro_sensor(set: TURN_OFF)
            if DEBUG{ print("gyro switch = \(gyro_switch.isOn)")}
        }

    }
    
    @IBOutlet weak var location_switch: UISwitch!
    @IBAction func toggle_location_sensor(_ sender: Any) {
        if location_switch.isOn {
            SensorViewController.location_switch_is_on = true
            if DEBUG {print("Start updating location")}
            SmartGPSManager.gps_instance.startGPSManagerUpdates()
        } else {
            SensorViewController.location_switch_is_on = false
            if DEBUG {print("Stop updating location")}
            SmartGPSManager.gps_instance.stopGPSManagerUpdates()
        }
    }
    
    /*  Meng Xu magnetometer */
    @IBOutlet weak var magnetometer_switch:UISwitch!
    @IBAction func toggle_magneto_sensor(_ sender: Any){
        if magnetometer_switch.isOn{
            
            if DEBUG { print("magneto switch = \(magnetometer_switch.isOn)")}
        }else{
            
            
            if DEBUG { print("magneto switch = \(magnetometer_switch.isOn)")}

        }
    }
    
    
    
    func set_switch_statuses(){
        accel_switch.setOn(SensorViewController.accel_switch_is_on, animated: false)
        gyro_switch.setOn(SensorViewController.gyro_switch_is_on, animated: false)
        location_switch.setOn(SensorViewController.location_switch_is_on, animated: false)
    }
    
 
    func configureSensors() -> Void {
        if DEBUG {print("Configure Sensors")}
        schedule_battery_timer()
        schedule_wifi_timer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        set_switch_statuses()
        configureSensors()
                // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

