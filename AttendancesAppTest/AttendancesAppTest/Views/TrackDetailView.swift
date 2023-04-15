//
//  TrackDetailView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/8/23.
//

import SwiftUI

struct TrackDetailView: View {
    @ObservedObject var data: HTTPClient
    var track: Track
    @State private var showingAddStudentToTrackView = false
    
    @State var selectedDate = Date()
    
    var startOfWeek = Calendar.current.date(from: DateComponents(year: 2023, month: 2, day: 13))!
    var endOfWeek = Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 30))!
    
    @State private var session = 0
    
    // Get all trackstudents for the track
    private func trackstudentsForTrack() -> [TrackStudent]? {
        let trackstudents = data.trackstudents.filter { $0.track_id == track.id }
        return trackstudents.isEmpty ? nil : trackstudents
    }
    
    // Get all attendances match the track
    private func attendancesForTrack() -> [Attendance]? {
        guard let trackstudents = trackstudentsForTrack() else { return [] }
        let attendances = data.attendances.filter { attendance in
            trackstudents.contains(where: { $0.id == attendance.trackstudent_id })
        }
        return attendances.isEmpty ? nil : attendances
    }
    
    // Get all attendances match the date
    private func attendancesForDate() -> [Attendance]? {
        guard let attendancesForTrack = attendancesForTrack() else { return nil }
        let formatter = DateFormatter()
        let attendances = attendancesForTrack.filter { attendance in
            let hoursInSeconds: TimeInterval = 60 * 60
            let dateWithOffset = attendance.date.addingTimeInterval(hoursInSeconds * 7)
            return dateWithOffset.formatted(date: .long, time: .omitted) == selectedDate.formatted(date: .long, time: .omitted)
        }
        return attendances.isEmpty ? nil : attendances
    }
    
    // Get all attendances match the session
    private func attendancesForSession() -> [Attendance]? {
        guard let attendancesForDate = attendancesForDate() else { return nil }
        let attendances = attendancesForDate.filter { $0.sessionNumber == String(session) }
        return attendances.isEmpty ? nil : attendances
    }

    // Get all trackstudents match the attendances
    private func trackstudentsForAttendances() -> [TrackStudent]? {
        guard let attendances = attendancesForSession() else { return nil }
        let filteredTrackStudents = data.trackstudents.filter { trackstudent in
            attendances.contains(where: { $0.trackstudent_id == trackstudent.id })
        }
        return filteredTrackStudents.isEmpty ? nil : filteredTrackStudents
    }

    // Get all students match the trackstudents
    private func studentsForTrackstudents() -> [Student]? {
        guard let trackstudents = trackstudentsForAttendances() else { return nil }
        let filteredStudents = data.students.filter { student in
            trackstudents.contains(where: { $0.student_id == student.id })
        }
        return filteredStudents.isEmpty ? nil : filteredStudents
    }
    
    private func startDate() -> Date {
        let hoursInSeconds: TimeInterval = 60 * 60
        let startDate = track.startDate.addingTimeInterval(hoursInSeconds * 7)
        return startDate
    }
    
    private func endDate() -> Date {
        let hoursInSeconds: TimeInterval = 60 * 60
        let endDate = track.endDate.addingTimeInterval(hoursInSeconds * 7)
        return endDate
    }

    var body: some View {
        
        List {
            Section {
                Text(track.name)
                Text(track.level)
                Text(track.location)
                ForEach(track.sessions.indices) { index in
                    let session = track.sessions[index]
                    VStack {
                        HStack {
                            Text("Session \(String(Character(UnicodeScalar(index + 65)!)).uppercased()) :")
                            Text(session)
                        }
                    }
                }
                Text("Start Date: \(startDate().formatted(date: .long, time: .omitted))")
                Text("End Date: \(endDate().formatted(date: .long, time: .omitted))")
            }
            
            Section {
                HStack {
                    
                    Image(systemName: "calendar")
                    DatePicker("Select Date", selection: $selectedDate, in: startOfWeek...endOfWeek, displayedComponents: .date)
                    }
                    
                    Picker("Session", selection: $session) {
                        ForEach(track.sessions.indices) { index in
                            Text("Session \(String(Character(UnicodeScalar(index + 65)!)).uppercased()) ")
                        }
                    }
                
                HStack {
                    Text("All Students").bold()
                    Spacer()
                    Text("Check in").bold()
                    Spacer()
                    Text("Check out").bold()
                    Spacer()
                    Button {
                        showingAddStudentToTrackView.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                            Text("Edit")
                        }
                    }
                    .frame(alignment: .trailing)
                }
                
                let attendances = attendancesForSession()
                let students = studentsForTrackstudents()

                if attendances == nil {
                    EmptyView()
                } else {
                    ForEach(attendances!.indices) { index in
                        HStack {
                            if students == nil {
                                EmptyView()
                            } else {
                                Text(students![index].name)
                            }
                            Spacer()
                            CheckInView(attendance: attendances![index])
                            Spacer()
                            CheckOutView(attendance: attendances![index])
                            Spacer()
                        }
                    }
                    .onAppear {
                        self.data.readData()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddStudentToTrackView, onDismiss: {
            self.data.readData()
        }, content: {
            AddStudentToTrackView(data: data, track: track, dismiss: $showingAddStudentToTrackView)
        })
    }
}

struct TrackDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let track = Track.example
        TrackDetailView(data: HTTPClient(), track: track)
    }
}
