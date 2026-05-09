//
//  SoundPresetTilePreview.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 5/9/26.
//
import SwiftUI

struct PresetTilePreview: View {
    @State var active = UUID()
    @State var tiles = [
        PackedTile(title: "Rain", resources: [
            SoundResource(text: "Rain", icon: "cloud.rain", soundName: "rain_session_vibe_crc", volume: Volume(percentVolume: 100)),
            SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "ruido_whitenoise", volume: Volume(percentVolume: 20))
        ])
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Theme.pink, location: 0),
                Gradient.Stop(color: Theme.purple, location: 0.7),
              ],
              center: .center,
              startRadius: 0,
              endRadius: UIScreen.main.bounds.height)
            .opacity(0.4)
            
            ForEach($tiles) { tile in
                SoundPresetTile(data: tile,
                                active: $active,
                                soundManager: SoundManager(sounds: []),
                                swapActiveCallback: swapActive)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func swapActive(id: UUID) {
        active = id
    }
}

#Preview {
    PresetTilePreview()
}
