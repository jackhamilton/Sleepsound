//
//  Timer.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import Foundation
import SwiftUI

//Swift mostly wants us to use Date, but for this we want a timer, and DateComponents seemed not to be operable in the ways I want.
struct Time: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    init(timeInterval: TimeInterval) {
        self.hours = Int(timeInterval) / 3600
        self.minutes = (Int(timeInterval) - (Int(hours) * 3600))/60
        self.seconds = Int(timeInterval) - (Int(hours) * 3600) - (Int(minutes) * 60)
    }
    
    func toString() -> String {
        let hoursString = twoDigitMinimumRepresentation(num: hours)
        let minutesString = twoDigitMinimumRepresentation(num: minutes)
        let secondsString = twoDigitMinimumRepresentation(num: seconds)
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    func timeInterval() -> TimeInterval {
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
    
    private func twoDigitMinimumRepresentation(num: Int) -> String {
        let stringRepresentation = String(num >= 0 ? num : 0)
        if stringRepresentation.count == 1 {
            return "0" + stringRepresentation
        } else {
            return stringRepresentation
        }
    }
}

class ShutoffTimer {
    var currentTime: Time
    var completion: () -> Void
    
    init(completion: @escaping () -> Void = {}) {
        let shutoffTime = Time(timeInterval: UserDefaults.standard.value(forKey: UserDefaultsDoubleKeys.ShutoffTimerDuration.rawValue) as? Double ?? 3600)
        self.currentTime = shutoffTime
        self.completion = completion
    }
    
    func text() -> String {
        return currentTime.toString()
    }
    
    func tick() {
        currentTime.seconds -= 1
        validate()
        if currentTime.seconds <= 0 && currentTime.minutes <= 0 && currentTime.hours <= 0 {
            completion()
        }
    }
    
    private func validate() {
        if currentTime.seconds < 0 && currentTime.minutes > 0 {
            currentTime.minutes -= 1
            currentTime.seconds = 59
        } else if currentTime.seconds < 0 && currentTime.hours > 0 {
            currentTime.hours -= 1
            currentTime.minutes = 59
            currentTime.seconds = 59
        }
    }
}
