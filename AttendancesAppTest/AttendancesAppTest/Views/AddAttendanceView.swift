//
//  AddAttendanceView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 3/29/23.
//

import SwiftUI

struct AddAttendanceView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var trackstudent_id = UUID()
    @State private var date = Date()
    @State private var sessionNumber = "0"
    @State private var checkInTime = Date()
    @State private var checkOutTime = Date()

    private func createAttendance() {
        HTTPClient().createAttendance(trackstudent_id: self.trackstudent_id, date: self.date, sessionNumber: self.sessionNumber, checkInTime: self.checkInTime, checkOutTime: self.checkOutTime) { success in
            if success {
                print("Attendance create successfully")
            } else {
                // show user the error message that save was not successful
                print("Failed to create Attendance ")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Text("Tap Button to Create")
            }
            .navigationTitle("Add new Attendance")
            .toolbar {
                Button("Create new Attendance") {
                    self.createAttendance()
                    dismiss()
                }
            }
        }
    }
}

struct AddAttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AddAttendanceView()
    }
}
