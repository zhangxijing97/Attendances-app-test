//
//  CheckInView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/12/23.
//

import SwiftUI

struct CheckInView: View {
    var attendance: Attendance
    @State var selectedDate = Date()
    @State private var isLoading = false
    
    private func updateAttendance(attendance: Attendance) {
        self.isLoading = true
        HTTPClient().updateAttendance(attendance) { success in
            if success {
                print("Attendance updated successfully.")
                HTTPClient().readData()
            } else {
                print("Attendance update failed.")
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    var body: some View {
        if attendance.checkInTime != Date(timeIntervalSince1970: 0) { // Check In Button For Section A
            Text(attendance.checkInTime.formatted(date: .omitted, time: .standard))
        } else {
            if isLoading {
                ProgressView()
            } else {
                Button(action: {}) {
                    Text("Check In")
                }
                .onTapGesture {
                    let hoursInSeconds: TimeInterval = 60 * 60
                    let date = attendance.date.addingTimeInterval(hoursInSeconds * 7)
                    
                    let attendance = Attendance(id: attendance.id, trackstudent_id: attendance.trackstudent_id, date: date, sessionNumber: attendance.sessionNumber, checkInTime: Date(), checkOutTime: attendance.checkOutTime)
                    self.updateAttendance(attendance: attendance)
                }
            }
        }
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(attendance: Attendance(id: UUID(), trackstudent_id: UUID(), date: Date(), sessionNumber: "0", checkInTime: Date(), checkOutTime: Date()))
    }
}
