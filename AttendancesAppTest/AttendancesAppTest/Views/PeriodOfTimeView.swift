//
//  PeriodOfTimeView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/7/23.
//

import SwiftUI

struct PeriodOfTimeView: View {
//    @State private var startDate = Date()
//    @State private var endDate = Date()
    
    @State private var startDate = Date()
    @State private var numberOfDays = 4

    private var endDate: Date {
        Calendar.current.date(byAdding: .day, value: numberOfDays, to: startDate)!
    }
    
    var body: some View {
        VStack {
            DatePicker(
                "Start Date",
                selection: $startDate,
                displayedComponents: [.date]
            )

            Stepper(
                value: $numberOfDays,
                in: 1...365,
                label: { Text("Number of Days: \(numberOfDays + 1)") }
            )

            DatePicker(
                "End Date",
                selection: Binding<Date>(
                    get: { endDate },
                    set: { newEndDate in
                        numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: newEndDate).day!
                    }
                ),
                displayedComponents: [.date]
            )
        }
        
        
        
        
//        VStack {
//            Text("Select a period of time")
//                .font(.title)
//                .padding()
//
//            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
//                .padding()
//
//            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date])
//                .padding()
//
//            Text("You selected \(numberOfDays) days")
//                .padding()
//        }
    }
//    var numberOfDays: Int {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
//        return components.day ?? 0
//    }

}

struct PeriodOfTimeView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodOfTimeView()
    }
}
