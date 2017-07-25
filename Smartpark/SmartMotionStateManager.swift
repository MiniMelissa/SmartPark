//
//  SmartMotionStateManager.swift
//  Smartpark
//
//  Created by Timothy Redband on 5/2/17.
//  Copyright © 2017 Timothy Redband. All rights reserved.
//

import Foundation
import CoreMotion


class SmartMotionStateManager {
    
    let motionstate_manager = CMMotionActivityManager()
    
    static let motionstate_instance = SmartMotionStateManager()
    
    private init(){
        configureMotionStateManager()
    }
    
    func startSmartMotionStateManager(){
        print("SmartMotionStateManager started")
    }

    private func get_motionstate_type(state: CMMotionActivity) -> Int {
        var activity_type: Int = -1
        if state.walking{
            activity_type = Android_MotionState.WALKING
        } else if state.running {
            activity_type = Android_MotionState.RUNNING
        } else if state.automotive {
            activity_type = Android_MotionState.IN_VEHICLE
        } else if state.stationary{
            activity_type = Android_MotionState.STILL
        } else if state.cycling {
            activity_type = Android_MotionState.ON_BICYCLE
        } else { //state.unknown
            activity_type = Android_MotionState.UNKNOWN
        }
        return activity_type
    }
    
    @objc func log_motionstate_status(state: CMMotionActivity) -> Void {
        if DEBUG {print("Log Motionstate status")}
        let timestamp = getDateinMilliseconds()
        let type = get_motionstate_type(state: state)
        _ = LocalDB.db_instance.insertMotionState(cuserid: USER_ID, ctimestamp: timestamp, cstate: Int64(type))
    }
    
    private func configureMotionStateManager() -> Void {
        if CMMotionActivityManager.isActivityAvailable() {
            motionstate_manager.startActivityUpdates(to: OperationQueue.current!){ (data) in
                if let motionstateData = data {
                    if motionstateData.confidence == CMMotionActivityConfidence.high {
                        self.log_motionstate_status(state: motionstateData)
                    }
                }
            }
        }
    }
    
    /*
    private func schedule_motionstate_timer() -> Void {
        motionstate_timer = Timer.scheduledTimer(timeInterval: MOTIONSTATE_TIMER_INTERVAL, target: self, selector: #selector(self.log_motionstate_status), userInfo: nil, repeats: true)
    }
 */

    
}
