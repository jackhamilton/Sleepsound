//
//  ContentView.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import SwiftUI
import Combine
import AVFAudio

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    var shutoffTime: Time
    @State var displayingTimePicker: Bool = false
    @State var activeID: UUID = UUID()
    @State var tiles: [PackedTile]
    @State var buttonIconMode = true
    
    static var soundManager: SoundManager = SoundManager(sounds: [
        SoundFile(filename: "rain_session.wav"),
        SoundFile(filename: "ruido_whitenoise.wav"),
        SoundFile(filename: "airplane_ambience.wav"),
        SoundFile(filename: "brownnoise.wav"),
        SoundFile(filename: "electricfan.wav"),
        SoundFile(filename: "industrialfan.wav"),
        SoundFile(filename: "lightrain_small.wav"),
        SoundFile(filename: "lightrain.wav"),
        SoundFile(filename: "mediumrain.wav"),
        SoundFile(filename: "pinknoise.wav"),
        SoundFile(filename: "restaurant.wav"),
        SoundFile(filename: "whitenoise.wav")
    ])
    
    init() {
        self.shutoffTime = Time(timeInterval: UserDefaults.standard.value(forKey: UserDefaultsDoubleKeys.ShutoffTimerDuration.rawValue) as? Double ?? 3600)
        
        var loadedPackedTiles: [PackedTile] = []
        if let packedTilesData = UserDefaults.standard.value(forKey: UserDefaultsDataKeys.PresetConfiguration.rawValue) as? Data {
            do {
                let decoder = JSONDecoder()
                let tiles = try decoder.decode([PackedTile].self, from: packedTilesData)
                loadedPackedTiles = tiles
            } catch {
                print("Error decoding packed tileset.")
            }
        }
        let defaultTiles = [
            PackedTile(title: "Light Rain", resources: [
                SoundResource(text: "Rain", icon: "cloud.drizzle", soundName: "rain_session", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ]),
            PackedTile(title: "Medium Rain", resources: [
                SoundResource(text: "Rain", icon: "cloud.rain", soundName: "lightrain_small", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ]),
            PackedTile(title: "Heavy Rain", resources: [
                SoundResource(text: "Rain", icon: "cloud.heavyrain", soundName: "lightrain", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ]),
            PackedTile(title: "Airplane", resources: [
                SoundResource(text: "Plane", icon: "airplane", soundName: "airplane_ambience", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ]),
            PackedTile(title: "Fan", resources: [
                SoundResource(text: "Rain", icon: "fan", soundName: "electricfan", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ]),
            PackedTile(title: "Restaurant", resources: [
                SoundResource(text: "Rain", icon: "cup.and.saucer", soundName: "restaurant", volume: Volume(percentVolume: 100)),
                SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "pinknoise", volume: Volume(percentVolume: 20))
            ])
        ]
        let mergedTiles: [PackedTile] = defaultTiles.map({ tile in
            if let packed = loadedPackedTiles.first(where: { $0.title == tile.title }) {
                return PackedTile(title: packed.title, icon: tile.icon, resources: packed.resources)
            } else {
                return tile
            }
        })
        _tiles = State(initialValue: mergedTiles)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                ScrollView {
                    ForEach($tiles) { tile in
                        SoundPresetTile(data: tile, active: $activeID, swapActiveCallback: swapActive)
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Soundspace")
                        .foregroundColor(Theme.text)
                        .font(.title)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        displayingTimePicker.toggle()
                    }, label: {
                        if buttonIconMode {
                            Image(systemName: "clock")
                                .foregroundColor(Theme.text)
                        } else {
                            Text("Timer")
                        }
                    })
                }
            }
            .sheet(isPresented: $displayingTimePicker) {
                TimePicker(selectedTime: shutoffTime)
                    .presentationDetents([.fraction(0.99), .medium])
            }
            .background(Theme.background)
        }
        .colorScheme(.dark)
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                let jsonEncoder = JSONEncoder()
                do {
                    let data = try jsonEncoder.encode(tiles)
                    UserDefaults.standard.setValue(data, forKey: UserDefaultsDataKeys.PresetConfiguration.rawValue)
                } catch {
                    print("Error encoding tile data.")
                }
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func swapActive(uuid: UUID) {
        activeID = uuid
    }
}

#Preview {
    ContentView()
}
