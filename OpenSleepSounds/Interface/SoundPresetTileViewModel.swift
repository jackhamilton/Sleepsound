//
//  SoundPresetTileViewModel.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 5/9/26.
//
import SwiftUI
import Combine

class SoundPresetTileViewModel: ObservableObject {
    @Published var playing = false
    
    public let volumePublisher = PassthroughSubject<(String, Volume), Never>()
    @Binding var data: PackedTile
    let soundManager: SoundManager
    
    var id = UUID()
    let swapActiveCallback: (UUID) -> Void
    
    public init(data: Binding<PackedTile>, soundManager: SoundManager, swapActiveCallback: @escaping (UUID) -> Void) {
        self.soundManager = soundManager
        self.swapActiveCallback = swapActiveCallback
        
        _data = data
    }
    
    func play() {
        swapActiveCallback(id)
        clearActiveSounds()
        
        playing = true
        
        for sound in data.resources {
            soundManager.playSound(sound.soundName)
            soundManager.updateVolume(soundName: sound.soundName, volume: sound.volume)
        }
    }
    
    func stop() {
        clearActiveSounds()
        playing = false
    }
    
    func clearActiveSounds() {
        soundManager.stopAll()
    }
}

extension SoundPresetTileViewModel: Equatable {
    static func == (lhs: SoundPresetTileViewModel, rhs: SoundPresetTileViewModel) -> Bool {
        if lhs.data.title == rhs.data.title {
            return true
        }
        return false
    }
}
