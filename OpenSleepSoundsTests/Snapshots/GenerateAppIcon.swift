//
//  GenerateAppIcon.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 5/9/26.
//

import XCTest
import OpenSleepSounds
import SwiftUI

final class GenerateAppIcon: XCTestCase {

    func generate_app_icon_snapshot_test() throws {
        assertSnapshot(of: AppIconComposition())
    }

}
