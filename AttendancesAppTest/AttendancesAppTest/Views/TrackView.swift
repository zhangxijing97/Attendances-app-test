//
//  TrackView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 3/27/23.
//

import SwiftUI

struct TrackView: View {
    @ObservedObject var data: HTTPClient
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Text("Count: \(data.tracks.count)")
                ForEach(data.tracks, id: \.id) { track in
                    NavigationLink(destination: TrackDetailView(data: data, track: track)) {
                        Text(track.name)
                    }
                }
            }
            .navigationTitle("Tracks")
            .navigationBarItems(trailing: Button(action: { self.isPresented = true }) {
                Image(systemName: "plus")
            })
            .onAppear { self.data.readData() }
        }
        .sheet(isPresented: $isPresented, onDismiss: { self.data.readData() }) {
            AddTrackView()
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(data: HTTPClient())
    }
}
