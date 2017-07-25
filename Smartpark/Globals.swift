//
//  Globals.swift
//  Smartpark
//
//  Created by Timothy Redband on 4/4/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import UIKit

struct Android_MotionState {
    static let IN_VEHICLE: Int = 0
    static let ON_BICYCLE: Int = 1
    static let RUNNING: Int = 8 
    static let STILL: Int = 3
    static let UNKNOWN: Int = 4
    static let WALKING: Int = 7
}

struct URL_TYPE {
    static let ACCEL: Int = 0
    static let GYRO: Int = 1
    static let GPS: Int = 2
    static let BATTERY: Int = 3
    static let STEP: Int = 4
    static let WIFI: Int = 5
    static let MOTIONSTATE: Int = 6
}


let USER_ID = UIDevice.current.identifierForVendor!.uuidString


let DEBUG: Bool = true
let DEBUGPOST: Bool = true
let DEBUGHTTP: Bool = true
let TURN_ON: Int = 10
let TURN_OFF: Int = -10

let NUM_ROWS_FOR_QUERY: Int = 5000

let SMARTPARK_BASE_URL: String = "http://cs.binghamton.edu/~smartpark/ios/"
let ACCELEROMETER_URL: String = "\(SMARTPARK_BASE_URL)accelerometer.php"
let GYROSCOPE_URL: String = "\(SMARTPARK_BASE_URL)gyroscope.php"
let GPS_URL: String = "\(SMARTPARK_BASE_URL)gps.php"
let BATTERY_URL: String = "\(SMARTPARK_BASE_URL)battery.php"
let STEP_URL: String = "\(SMARTPARK_BASE_URL)step.php"
let WIFI_URL: String = "\(SMARTPARK_BASE_URL)wifi.php"
let MOTIONSTATE_URL: String = "\(SMARTPARK_BASE_URL)motionstate.php"



//Values in seconds
let DEFAULT_SAMPLING_RATE: Double = 0.1
let LOW_SAMPLING_RATE: Double = 0.1
let MEDIUM_SAMPLING_RATE: Double = 0.05
let HIGH_SAMPLING_RATE: Double = 0.02


//Values in seconds
let BATTERY_TIMER_INTERVAL: Double = 60
let WIFI_TIMER_INTERVAL: Double = 60
//let MOTIONSTATE_TIMER_INTERVAL: Double = 5
//let POST_TIMER_INTERVAL: Double = 180


var accel_sem = DispatchSemaphore(value: 1)
var gyro_sem = DispatchSemaphore(value: 1)
var battery_sem = DispatchSemaphore(value: 1)
var wifi_sem = DispatchSemaphore(value: 1)
var gps_sem = DispatchSemaphore(value: 1)
var motionstate_sem = DispatchSemaphore(value: 1)
var step_sem = DispatchSemaphore(value: 1)

let SEM_WAIT_INTERVAL = DispatchTime.now() + DispatchTimeInterval.seconds(60)

func getDateinMilliseconds() -> Int64 {
    let date = Date().timeIntervalSince1970
    let date_int_floor = Int64(floor(date * 1000))
    return date_int_floor
}

func get_midnight_of_current_day() -> Date {
    var cal = Calendar.current
    var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    comps.hour = 0
    comps.minute = 0
    comps.second = 0
    let timeZone = TimeZone.current
    cal.timeZone = timeZone
    let midnightOfToday = cal.date(from: comps)!
    return midnightOfToday
}



