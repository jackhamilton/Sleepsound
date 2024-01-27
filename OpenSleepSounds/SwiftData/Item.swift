//
//  Item.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
