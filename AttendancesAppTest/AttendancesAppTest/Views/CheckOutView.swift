//
//  CheckOutView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/12/23.
//

import SwiftUI

struct CheckOutView: View {
    var attendance: Attendance
    
    var body: some View {
        Text("\(attendance.checkOutTime)" as String)
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(attendance: Attendance(id: UUID(), trackstudent_id: UUID(), date: Date(), sessionNumber: "0", checkInTime: Date(), checkOutTime: Date()))
    }
}
