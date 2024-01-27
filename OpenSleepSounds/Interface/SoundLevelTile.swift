//
//  SoundLevelTile.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import Foundation
import SwiftUI
import Combine

struct SoundLevelTile: View {
    var sound: SoundResource
    var volumePublisher: PassthroughSubject<(String, Volume), Never>?
    @State var volume: Volume
    @Binding var active: Bool
    
    init(sound: SoundResource, active: Binding<Bool>, volumePublisher: PassthroughSubject<(String, Volume), Never>? = nil) {
        self.sound = sound
        _volume = State(initialValue: sound.volume)
        _active = active
        self.volumePublisher = volumePublisher
    }
    
    var body: some View {
        HStack {
            if let icon = sound.icon {
                Image(systemName: icon)
                    .foregroundColor(Theme.text)
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            } else {
                Text(sound.text)
                    .foregroundColor(Theme.text)
                    .font(.system(size: 30))
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            }
            
//            Slider(value: $sound.volume.rawValue, in: 0...1)
//                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
//                .onChange(of: sound.volume, {
//                    if active {
//                        ContentView.soundManager.updateVolume(soundName: sound.soundName, volume: sound.volume)
//                    }
//                })
            Slider(value: $volume.rawValue)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                .onChange(of: volume, {
                    volumePublisher?.send((sound.soundName, volume))
                })
            
            Text(volume.formatted())
                .foregroundColor(Theme.text)
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                .frame(minWidth: 75, maxWidth: 75)
        }
    }
}

struct LevelTilePreviewView: View {
    var sound = SoundResource(text: "whitenoise", icon: "cloud.rain", soundName: "ruido_whitenoise", volume: Volume(decimalVolume: 0.5))
    @State var active = true
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            SoundLevelTile(sound: sound, active: $active)
        }
    }
}

//Alternate slider, currently unused
struct VolumeSlider: View {
    @Binding var volume: Volume

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * CGFloat(volume.rawValue))
            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    // TODO: - maybe use other logic here
                    volume = Volume(decimalVolume: min(max(0, Double(value.location.x / geometry.size.width)), 1))
                }))
        }
        .frame(maxHeight: 12)
    }
}

#Preview {
    LevelTilePreviewView()
}
