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
        ZStack {
            Theme.timer.edgesIgnoringSafeArea(.all)
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
                    selectedTime = Time(timeInterval: updatedTime)
                    dismiss()
                }
                .foregroundColor(Theme.action)
                .padding()
            }
        }
        
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
