//
//  AppIconCaptureLaunchTests.swift
//  AppIconCapture
//
//  Created by Jack Hamilton on 5/9/26.
//
import UIKit
import SwiftUI
import SnapshotTesting
import Testing

@Suite
struct AppIconCaptureTests {

    @MainActor
    @Test
    func appIcon() {
        let vc = UIHostingController(rootView: AppIcon().frame(width: 512,
                                                               height: 512))

        assertSnapshot(of: vc,
                       as: .image(drawHierarchyInKeyWindow: true,
                                  size: CGSize(width: 512,
                                               height: 512)),
                       record: true)
    }
}
