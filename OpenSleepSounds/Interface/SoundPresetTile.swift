//
//  ContentView.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/24/24.
//

import SwiftUI
import SwiftySound
import Combine

struct SoundPresetTile: View, Identifiable {
    var id: UUID {
        return viewModel.id
    }
    
    @Binding var activeUUID: UUID
    @State var isActive = false
    @State var expanded = false
    
    @ObservedObject var viewModel: SoundPresetTileViewModel
    @ObservedObject var shutoffTimer = ShutoffTimer()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(data: Binding<PackedTile>,
         active: Binding<UUID>,
         soundManager: SoundManager,
         swapActiveCallback: @escaping (UUID) -> Void) {
        self.viewModel = SoundPresetTileViewModel(data: data,
                                                  soundManager: soundManager,
                                                  swapActiveCallback: swapActiveCallback)

        _activeUUID = active
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: .leastNonzeroMagnitude, content: {
                if let icon = viewModel.data.icon {
                    imageIcon(systemName: icon)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                }
                Text(viewModel.data.title)
                    .foregroundStyle(Theme.text)
                    .font(.title2)
                    .padding(5)
                
                Spacer()
                
                playControls
                expando
            })
            .frame(maxWidth: UIScreen.main.bounds.width)
            .scaledToFit()
            
            if expanded {
                ForEach($viewModel.data.resources) { sound in
                    SoundLevelTile(sound: sound.wrappedValue,
                                   soundManager: viewModel.soundManager,
                                   active: $isActive,
                                   volumePublisher: viewModel.volumePublisher)
                    .onReceive(viewModel.volumePublisher, perform: { name, volume in
                        if let updateIndex = viewModel.data.resources.firstIndex(where: { $0.soundName == name }) {
                            viewModel.data.resources[updateIndex].volume = volume
                        }
                    })
                }
            }
        }
        .padding()
        .background(Material.regular)
        .cornerRadius(24)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .onChange(of: activeUUID, {
            isActive = activeUUID == id
        })
        .animation(.bouncy, value: expanded)
    }
    
    func imageIcon(systemName: String, color: Color = Theme.text) -> some View {
        Image(systemName: systemName)
            .foregroundColor(color)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    var playControls: some View {
        if viewModel.playing && isActive {
            Text(shutoffTimer.associatedText)
                .foregroundStyle(Theme.text)
                .padding(5)
                .onReceive(timer, perform: { _ in
                    shutoffTimer.tick()
                })
                .transition(.push(from: .top))
            Button(action: {
                viewModel.stop()
            }, label: {
                imageIcon(systemName: "stop.fill", color: Theme.action)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .transition(.symbolEffect)
            })
        } else {
            Button(action: {
                shutoffTimer.reset()
                viewModel.play()
            }, label: {
                imageIcon(systemName: "play.fill", color: Theme.action)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .transition(.symbolEffect)
            })
        }
    }
    
    var expando: some View {
        Button(action: {
            expanded.toggle()
        }, label: {
            if expanded {
                imageIcon(systemName: "chevron.up", color: Theme.action)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .transition(.symbolEffect)
            } else {
                imageIcon(systemName: "chevron.down", color: Theme.action)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .transition(.symbolEffect)
            }
        })
    }
}

#Preview {
    PresetTilePreview()
}
