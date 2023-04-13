//
//  DateTestView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/8/23.
//

import SwiftUI

struct DateTestView: View {
    @State private var startDate = Date()
    @State private var startTime = Date()
    @State private var startDateTime: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            Button("Combine Date and Time") {
                // Combine the date and time components of startDate and startTime
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
                let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: startTime)
                let combinedComponents = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, second: timeComponents.second)
                
                // Use the calendar to create a new Date object for the combined date and time
                startDateTime = calendar.date(from: combinedComponents)!
            }
            Text("Start Date and Time: \(startDateTime)")
        }
    }
}

struct DateTestView_Previews: PreviewProvider {
    static var previews: some View {
        DateTestView()
    }
}
