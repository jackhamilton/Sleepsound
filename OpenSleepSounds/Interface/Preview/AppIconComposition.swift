//
//  AppIconComposition.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 5/9/26.
//
import SwiftUI

@available(iOS 26.0, *)
struct AppIconComposition: View {
    var body: some View {
        ZStack {
            Image(ImageResource(name: "appicon_bg", bundle: .main))
            Image(systemName: "waveform")
                .resizable()
                .foregroundStyle(Theme.pink)
                .padding(32)
                .glassEffect()
                .padding(32)
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        AppIconComposition()
    } else {}
}
