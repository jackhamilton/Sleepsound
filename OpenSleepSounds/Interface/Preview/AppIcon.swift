//
//  AppIcon.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 5/9/26.
//

import SwiftUI

@available(iOS 26.0, *)
struct AppIcon: View {
    var body: some View {
        ZStack {
            Image(ImageResource(name: "appicon_bg", bundle: .main))
                .resizable()
                .scaledToFill()
            Image(systemName: "waveform")
                .resizable()
                .foregroundStyle(Theme.pink)
                .padding(32)
                .glassEffect()
                .padding(32)
        }
        .frame(width: 512, height: 512)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        AppIcon()
    } else {}
}
