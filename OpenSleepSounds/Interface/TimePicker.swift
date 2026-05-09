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
    @Binding var selectedTime: Time
    
    init(selectedTime: Binding<Time>) {
        _selectedTime = selectedTime
        preservedStartOfDay = Calendar.current.startOfDay(for: Date())
        _date = State(initialValue: preservedStartOfDay.addingTimeInterval(selectedTime.wrappedValue.timeInterval()))
    }

    var body: some View {
        VStack {
            Text("Sleep Timer Length")
                .font(.title3)
                .foregroundStyle(Theme.glassText)
            
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.hourAndMinute]
            )
            .colorScheme(.light)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ru"))
            .datePickerStyle(.wheel)
            
            if #available(iOS 26.0, *) {
                button
                    .glassEffect()
            } else {
                button
                    .padding(6)
                    .buttonStyle(.bordered)
            }
        }
    }
    
    var button: some View {
        Button(action: {
            let updatedTime = date.timeIntervalSinceReferenceDate - preservedStartOfDay.timeIntervalSinceReferenceDate
            UserDefaults.standard.setValue(Double(updatedTime), forKey: UserDefaultsDoubleKeys.ShutoffTimerDuration.rawValue)
            selectedTime = Time(timeInterval: updatedTime)
            dismiss()
        }, label: {
            Text("Confirm")
        })
        .foregroundColor(Theme.glassAction)
        .padding()
    }
}

struct TimePickerPreview: View {
    @State var selectedTime: Time = Time(hours: 1, minutes: 0, seconds: 0)
    
    var body: some View {
        TimePicker(selectedTime: $selectedTime)
    }
}

#Preview {
    TimePickerPreview()
}
