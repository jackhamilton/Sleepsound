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
    
    @StateObject var viewModel = ContentViewModel()
    
    @State var activeID: UUID = UUID()
    @State var displayingTimePicker: Bool = false
    @State var buttonIconMode = true

    var body: some View {
        NavigationStack {
            interface
        }
        .colorScheme(.dark)
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background,
                 .inactive:
                viewModel.save()
            default:
                return
            }
        }
    }
    
    var interface: some View {
        ZStack {
            ScrollView {
                ForEach($viewModel.tiles) { tile in
                    SoundPresetTile(data: tile,
                                    active: $activeID,
                                    soundManager: viewModel.soundManager,
                                    swapActiveCallback: swapActive)
                }
                .animation(.bouncy)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    displayingTimePicker.toggle()
                }, label: {
                    if buttonIconMode {
                        Image(systemName: "gear")
                            .foregroundColor(Theme.text)
                    } else {
                        Text("Timer")
                    }
                })
            }
        }
        .sheet(isPresented: $displayingTimePicker) {
            TimePicker(selectedTime: $viewModel.shutoffTime)
                .presentationDetents([.fraction(0.99), .medium])
        }
        .background {
            RadialGradient(stops: [
                Gradient.Stop(color: Theme.pink.opacity(0.8), location: 0),
                Gradient.Stop(color: Theme.purple.opacity(0.5), location: 0.7),
              ],
              center: .center,
              startRadius: 0,
              endRadius: UIScreen.main.bounds.height)
            .ignoresSafeArea()
        }
    }
    
    func swapActive(uuid: UUID) {
        activeID = uuid
    }
}

#Preview {
    ContentView()
}
