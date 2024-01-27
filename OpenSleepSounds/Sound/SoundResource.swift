//
//  SoundResource.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/25/24.
//

import Foundation
import SwiftUI

struct SoundResource: Identifiable, Codable {
    var id = UUID()
    
    let text: String
    let icon: String?
    let soundName: String
    //out of 100
    var volume: Volume
    
    init(text: String, icon: String? = nil, soundName: String, volume: Volume) {
        self.text = text
        self.icon = icon
        self.soundName = soundName
        self.volume = volume
    }
}

struct PackedTile: Codable, Identifiable {
    var id = UUID()
    
    var title: String
    var icon: String?
    var resources: [SoundResource]
    
    init(title: String, icon: String? = nil, resources: [SoundResource]) {
        self.title = title
        self.icon = icon
        self.resources = resources
    }
}

struct SoundFile: Identifiable {
    var id = UUID()
    let filename: String
}
