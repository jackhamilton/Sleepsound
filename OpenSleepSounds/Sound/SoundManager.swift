//
//  SoundManager.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/25/24.
//

import Foundation
import SwiftySound

public class SoundManager {
    private var initializedSounds: [String: Sound]
    
    init(sounds: [SoundFile]) {
        Sound.category = .playback
        initializedSounds = [:]
        for sound in sounds {
            let fileIdentifier = sound.filename.split(separator: ".")
            if let nameSequence = fileIdentifier.first,
               let typeSequence = fileIdentifier.last {
                //File provided in proper format with name and extension
                let name = String(nameSequence)
                let type = String(typeSequence)
                if let path = Bundle.main.path(forResource: name, ofType: type) {
                    //Corresponding file exists
                    let url = URL(fileURLWithPath: path)
                    if let provisionedSound = Sound(url: url) {
                        //File was usable to create a sound resource
                        initializedSounds[name] = provisionedSound
                    }
                } else {
                    print("Failed to load resource SoundFiles/\(name).\(type)")
                }
            }
        }
    }
    
    //TODO: Ensure this is pass by reference
    func playSound(_ soundName: String) {
        if let sound = initializedSounds[soundName] {
            sound.play(numberOfLoops: -1)
        } else {
            print("Error playing sound: resource not found.")
        }
    }
    
    func stopSound(_ soundName: String) {
        if let sound = initializedSounds[soundName] {
            sound.stop()
        } else {
            print("Error stopping sound: resource not found.")
        }
    }
    
    func updateVolume(soundName: String, volume: Volume) {
        if let sound = initializedSounds[soundName] {
            sound.volume = Float(volume.rawValue)
        } else {
            print("Error adjusting sound volume: resource not found.")
        }
    }
    
    func stopAll() {
        initializedSounds.keys.forEach({ key in
            initializedSounds[key]?.stop()
        })
    }
}
