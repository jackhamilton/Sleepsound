//
//  TimePicker.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 1/25/24.
//

import Foundation
import SwiftUI

struct TimePicker: View {
    @Environment(\.dismiss) var dismiss
    
    var preservedStartOfDay: Date
    @State var date: Date
    
    init(selectedTime: Time) {
        preservedStartOfDay = Calendar.current.startOfDay(for: Date())
        _date = State(initialValue: preservedStartOfDay.addingTimeInterval(selectedTime.timeInterval()))
    }

    var body: some View {
        ZStack {
            Theme.foreground.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Set Sleep Timer Length")
                    .font(.title2)
                    .foregroundStyle(Theme.text)
                
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.hourAndMinute]
                )
                .colorScheme(.dark)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ru"))
                .datePickerStyle(.wheel)
                
                Button("Confirm") {
                    let updatedTime = date.timeIntervalSinceReferenceDate - preservedStartOfDay.timeIntervalSinceReferenceDate
                    UserDefaults.standard.setValue(Double(updatedTime), forKey: UserDefaultsDoubleKeys.ShutoffTimerDuration.rawValue)
                    dismiss()
                }
                .foregroundColor(Theme.action)
                .padding()
            }
        }
        
    }
}

#Preview {
    TimePicker(selectedTime: Time(hours: 1, minutes: 0, seconds: 0))
}
