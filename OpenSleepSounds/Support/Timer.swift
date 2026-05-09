//
//  Timer.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import Foundation
import SwiftUI
import Combine

//Swift mostly wants us to use Date, but for this we want a timer, and DateComponents seemed not to be operable in the ways I want.
struct Time: Codable, Equatable {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var text: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 2
        formatter.minimumIntegerDigits = 2
        
        let hoursString = formatter.string(from: NSNumber(value: hours))
        let minutesString = formatter.string(from: NSNumber(value: minutes))
        let secondsString = formatter.string(from: NSNumber(value: seconds))
        guard let hoursString,
              let minutesString,
              let secondsString else { return "" }
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
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
    
    func timeInterval() -> TimeInterval {
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
}

class ShutoffTimer: ObservableObject {
    @Published var currentTime: Time
    @Published var associatedText: String = ""
    
    var completion: () -> Void
    var cancelBag = Set<AnyCancellable>()
    
    var storedTimerDuration: Time {
        Time(timeInterval: UserDefaults.standard.value(forKey: UserDefaultsDoubleKeys.ShutoffTimerDuration.rawValue) as? Double ?? 3600)
    }
    
    init(completion: @escaping () -> Void = {}) {
        // computed properties use self
        self.currentTime = Time(timeInterval: 0)
        self.completion = completion
        self.currentTime = storedTimerDuration
        
        $currentTime.sink { [weak self] time in
            self?.associatedText = time.text
        }
        .store(in: &cancelBag)
    }
    
    func tick() {
        currentTime.seconds -= 1
        validate()
        
        if currentTime.seconds <= 0 && currentTime.minutes <= 0 && currentTime.hours <= 0 {
            completion()
        }
    }
    
    func reset() {
        currentTime = storedTimerDuration
    }
    
    // Accounts for carried places
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
