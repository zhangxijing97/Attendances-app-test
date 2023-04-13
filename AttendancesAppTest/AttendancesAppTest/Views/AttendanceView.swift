//
//  AttendanceView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 3/27/23.
//

import SwiftUI

struct AttendanceView: View {
    @ObservedObject var data: HTTPClient
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Text("Count: \(data.attendances.count)")
                ForEach(data.attendances, id: \.id) { attendance in
                    Text("\(attendance.date)")
                    Text("\(attendance.checkInTime)")
                }
            }
            .navigationTitle("Attendances")
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = true
            }){
                Image(systemName: "plus")
            })
            .onAppear {
                self.data.readData()
            }
        }
        .sheet(isPresented: $isPresented, onDismiss: {
            self.data.readData()
        }, content: {
            AddAttendanceView()
        })
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(data: HTTPClient())
    }
}
