//
//  Volume.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/25/24.
//

import Foundation

public struct Volume: Codable, Equatable {
    var rawValue: Double
    
    init(percentVolume: Int) {
        self.rawValue = Double(percentVolume) / 100
    }
    
    init(decimalVolume: Double) {
        self.rawValue = decimalVolume
    }
    
    func decimalRepresentation() -> Double {
        return rawValue
    }
    
    func percentRepresentation() -> Int {
        return Int(rawValue * 100)
    }
    
    func formatted() -> String {
        return "\(percentRepresentation())%"
    }
}
