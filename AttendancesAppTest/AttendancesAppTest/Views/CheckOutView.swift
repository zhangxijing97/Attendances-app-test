//
//  CheckOutView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/12/23.
//

import SwiftUI

struct CheckOutView: View {
    var attendance: Attendance
    @State var selectedDate = Date()
    
    private func updateAttendance(attendance: Attendance) {
        HTTPClient().updateAttendance(attendance) { success in
            if success {
                print("Attendance updated successfully.")
                HTTPClient().readData()
            } else {
                print("Attendance update failed.")
            }
        }
    }
    
    var body: some View {
        if attendance.checkOutTime != Date(timeIntervalSince1970: 0) { // Check In Button For Section A
            Text(attendance.checkOutTime.formatted(date: .omitted, time: .standard))
        } else {
            Button(action: {}) {
                Text("Check Out")
            }
            .onTapGesture {
                let hoursInSeconds: TimeInterval = 60 * 60
                let date = attendance.date.addingTimeInterval(hoursInSeconds * 7)

                let attendance = Attendance(id: attendance.id, trackstudent_id: attendance.trackstudent_id, date: date, sessionNumber: attendance.sessionNumber, checkInTime: attendance.checkInTime, checkOutTime: Date())
                self.updateAttendance(attendance: attendance)
            }
        }
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(attendance: Attendance(id: UUID(), trackstudent_id: UUID(), date: Date(), sessionNumber: "0", checkInTime: Date(), checkOutTime: Date()))
    }
}
