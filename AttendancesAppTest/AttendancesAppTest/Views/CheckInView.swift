//
//  CheckInView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/12/23.
//

import SwiftUI

struct CheckInView: View {
    @ObservedObject var data: HTTPClient
    var attendance: Attendance
    @State private var isLoading = false
    var onUpdate: () -> Void // Add this line
    
    private func updateAttendance(attendance: Attendance) {
        self.isLoading = true
        HTTPClient().updateAttendance(attendance) { success in
            if success {
                print("Attendance updated successfully.")
                onUpdate()
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
        CheckInView(data: HTTPClient(), attendance: Attendance(id: UUID(), trackstudent_id: UUID(), date: Date(), sessionNumber: "0", checkInTime: Date(), checkOutTime: Date()), onUpdate: {})
    }
}
