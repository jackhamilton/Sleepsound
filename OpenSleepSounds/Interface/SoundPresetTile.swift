//
//  ContentView.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import SwiftUI
import SwiftySound
import Combine

struct SoundPresetTile: View, Identifiable, Equatable {
    //Not using this as source of truth since saving it could create issues
    var id = UUID()
    static func == (lhs: SoundPresetTile, rhs: SoundPresetTile) -> Bool {
        if lhs.data.title == rhs.data.title {
            return true
        }
        return false
    }
    
    //Source of truth
    @Binding var data: PackedTile
    public let volumePublisher = PassthroughSubject<(String, Volume), Never>()
    
    let dateFormatter: DateFormatter
    let swapActiveCallback: (UUID) -> Void
    
    @Binding var activeUUID: UUID
    @State var isActive: Bool
    @State var timerText: String = ""
    @State var expanded: Bool = false
    @State var playing: Bool = false
    @State var shutoffTimer: ShutoffTimer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(data: Binding<PackedTile>, active: Binding<UUID>, swapActiveCallback: @escaping (UUID) -> Void) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "hh:mm:ss"
        self.swapActiveCallback = swapActiveCallback
        _data = data
        _activeUUID = active
        _isActive = State(initialValue: false)
        _shutoffTimer = State(initialValue: ShutoffTimer())
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: .leastNonzeroMagnitude, content: {
                if let icon = self.data.icon {
                    Image(systemName: icon)
                        .colorInvert()
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 5))
                }
                Text(data.title)
                    .foregroundStyle(Theme.text)
                    .font(.title2)
                    .padding(5)
                Spacer()
                if playing && isActive {
                    Text(timerText)
                        .foregroundStyle(Theme.text)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .onReceive(timer, perform: { _ in
                            shutoffTimer.tick()
                            timerText = shutoffTimer.text()
                        })
                    Button(action: {
                        stop()
                    }, label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 15))
                    })
                } else {
                    Button(action: {
                        play()
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 15))
                    })
                }
                Button(action: {
                    toggleExpand()
                }, label: {
                    if expanded {
                        Image(systemName: "chevron.up")
                            .foregroundColor(Theme.text)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 15))
                    } else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Theme.text)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 15))
                    }
                })
            })
            .background(Theme.foreground)
            .frame(maxWidth: UIScreen.main.bounds.width)
            .scaledToFit()
            
            if expanded {
                ForEach($data.resources) { sound in
                    SoundLevelTile(sound: sound.wrappedValue, active: $isActive, volumePublisher: volumePublisher)
                        .onReceive(volumePublisher, perform: { name, volume in
                            if let updateIndex = data.resources.firstIndex(where: { $0.soundName == name }) {
                                data.resources[updateIndex].volume = volume
                            }
                        })
                }
            }
        }
        .padding()
        .background(Theme.foreground)
        .onChange(of: activeUUID, {
            isActive = activeUUID == id
        })
    }
    
    func play() {
        swapActiveCallback(id)
        clearActiveSounds()
        self.shutoffTimer = ShutoffTimer(completion: {
            stop()
        })
        playing = true
        timerText = shutoffTimer.text()
        shutoffTimer.completion = {
            stop()
        }
        for sound in data.resources
        {
            ContentView.soundManager.playSound(sound.soundName)
            ContentView.soundManager.updateVolume(soundName: sound.soundName, volume: sound.volume)
        }
    }
    
    func stop() {
        clearActiveSounds()
        playing = false
    }
    
    func clearActiveSounds() {
        ContentView.soundManager.stopAll()
    }
    
    func toggleExpand() {
        expanded = !expanded
    }
}

struct PresetTilePreviewView: View {
    @State var active = UUID()
    @State var tiles = [
        PackedTile(title: "Rain", resources: [
            SoundResource(text: "Rain", icon: "cloud.rain", soundName: "rain_session_vibe_crc", volume: Volume(percentVolume: 100)),
            SoundResource(text: "Noise", icon: "chart.bar.xaxis", soundName: "ruido_whitenoise", volume: Volume(percentVolume: 20))
        ])
    ]
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            ForEach($tiles) { tile in
                SoundPresetTile(data: tile, active: $active, swapActiveCallback: swapActive)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func swapActive(id: UUID) {
        active = id
    }
}

#Preview {
    PresetTilePreviewView()
}
