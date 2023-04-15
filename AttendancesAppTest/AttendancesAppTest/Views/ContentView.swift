//
//  ContentView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 3/26/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data = HTTPClient()
    
    var body: some View {
        TabView {
            StudentView(data: data)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("StudentView")
                }
            TrackView(data: data)
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("TrackView")
                }
//            SessionView(data: data)
//                .tabItem {
//                    Image(systemName: "3.circle")
//                    Text("SessionView")
//                }
//            AttendanceView(data: data)
//                .tabItem {
//                    Image(systemName: "4.circle")
//                    Text("AttendanceView")
//                }
        }
        .onAppear {
            self.data.readData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(data: HTTPClient())
    }
}
