//
//  CheckInView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/12/23.
//

import SwiftUI

struct CheckInView: View {
    var attendance: Attendance
    
//    @State var selectedDate = Date()
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter
    }
    
    private func updateAttendance(attendance: Attendance) {
        
        HTTPClient().updateAttendance(attendance) { success in
            if success {
                print("Attendance updated successfully.")
            } else {
                print("Attendance update failed.")
            }
        }
    }
    
    var body: some View {
//        Text("\(attendance.checkInTime)" as String)
        if attendance.checkInTime != Date(timeIntervalSince1970: 0) { // Check In Button For Section A
//            Text("\(attendance.checkInTime, formatter: dateFormatter)")
            Text("\(attendance.checkInTime)" as String)
        } else {
            Button(action: {
                
            }) {
                Text("Check In")
            }
            .onTapGesture {
                
                let attendance = Attendance(id: attendance.id, trackstudent_id: attendance.trackstudent_id, date: attendance.date, sessionNumber: attendance.sessionNumber, checkInTime: Date(), checkOutTime: attendance.checkOutTime)
                
                self.updateAttendance(attendance: attendance)
                
            }
        }
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(attendance: Attendance(id: UUID(), trackstudent_id: UUID(), date: Date(), sessionNumber: "0", checkInTime: Date(), checkOutTime: Date()))
    }
}
