//
//  SessionView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/6/23.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var data: HTTPClient
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Text("Count: \(data.sessions.count)")
                ForEach(data.sessions, id: \.id) { session in
                    Text("\(session.date)")
                    Text("\(session.startTime)") // For testing
                }
            }
            .navigationTitle("Sessions")
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = true
            }){
                Image(systemName: "plus")
            })
            .onAppear {
                self.data.readSession()
            }
        }
        .sheet(isPresented: $isPresented, onDismiss: {
            self.data.readSession()
        }, content: {
            EmptyView()
        })
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(data: HTTPClient())
    }
}
