//
//  SmartMotionSensorsManager.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/2/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import CoreMotion

class SmartMotionSensorsManager {
    
    let motion_manager = CMMotionManager()

    static let motion_sensors_instance = SmartMotionSensorsManager()
    
    private init(){
        configureMotionManager()
    }
    
    func startSmartMotionSensorsManager(){
        print("SmartMotionSensorsManager started")
    }

    
    private func configureMotionManager() -> Void {
        motion_manager.accelerometerUpdateInterval = DEFAULT_SAMPLING_RATE
        motion_manager.gyroUpdateInterval = DEFAULT_SAMPLING_RATE
        set_accel_sensor(set: TURN_ON)
        set_gyro_sensor(set: TURN_ON)
    }
    
    func set_accel_sensor(set: Int) -> Void {
        if set == TURN_ON{
            if DEBUG {print("Set accel sensor")}
            motion_manager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
                if let accelData = data {
                    let timestamp = getDateinMilliseconds()
                    let x = accelData.acceleration.x
                    let y = accelData.acceleration.y
                    let z = accelData.acceleration.z
                    _ = LocalDB.db_instance.insertAccelerometer(cuserid: USER_ID, ctimestamp: timestamp, cx: x, cy: y, cz: z)
                }
            }
        } else {
            if DEBUG {print("Stop accel sensor")}
            motion_manager.stopAccelerometerUpdates()
        }
        return
    }
    
    func set_gyro_sensor(set: Int) -> Void {
        if set == TURN_ON {
            if DEBUG {print("Set gyro sensor")}
            motion_manager.startGyroUpdates(to: OperationQueue.current!){ (data, error) in
                if let gyroData = data {
                    let timestamp = getDateinMilliseconds()
                    let x = gyroData.rotationRate.x
                    let y = gyroData.rotationRate.y
                    let z = gyroData.rotationRate.z
                    _ = LocalDB.db_instance.insertGyroscope(cuserid: USER_ID, ctimestamp: timestamp, cx: x, cy: y, cz: z)
                }
            }
        } else {
            if DEBUG {print("Stop gyro sensor")}
            motion_manager.stopGyroUpdates()
        }
    }
    
    //meng xu TODO !  search how to get magnetometer sensor value in swift
    /*
    func set_magnetometer_sensor(set: Int)->Void{
        if set == TURN_ON{
            if DEBUG { print("Set magnetometer sensor")
                motion_manager.startMagnetometerUpdates(to: OperationQueue.current!{(data,error) in
                    if let magData = data{
                        let timestamp = getDateinMilliseconds()
                        let x = magData.
                        let y = magData.
                    }
                }
        }
    }
 */
    
    
    
    //updates the sampling rate on accel and gyro based on value of UISegmented control selected by user
    func updateSamplingRates(new_rate: Double) -> Void {
        motion_manager.accelerometerUpdateInterval = new_rate
        motion_manager.gyroUpdateInterval = new_rate
    }


    
}
