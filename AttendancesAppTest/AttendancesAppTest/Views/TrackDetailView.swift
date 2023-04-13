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
    @State private var showingAddStudentToTrackView = false // Show
    
    @State var selectedDate = Date()
//    @State private var selectedDate: Date = {
//        let timeZone = TimeZone(identifier: "UTC")!
//        let calendar = Calendar(identifier: .gregorian)
//        let now = Date()
//        let components = calendar.dateComponents(in: timeZone, from: now)
//        return calendar.date(from: components)!
//    }()

    let dateFormatter = DateFormatter()
    var startOfWeek = Calendar.current.date(from: DateComponents(year: 2023, month: 2, day: 13))!
    var endOfWeek = Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 30))!
    
    @State private var session = 0
    
    // Get all attendances match the track
    var trackstudentsForTrack: [TrackStudent]? {
        let trackstudents = data.trackstudents.filter { $0.track_id == track.id }
        return trackstudents.isEmpty ? nil : trackstudents
    }
    
    var attendancesForTrack: [Attendance]? {
        guard let trackstudents = trackstudentsForTrack else { return nil }
        let attendances = data.attendances.filter { attendance in
            trackstudents.contains(where: { $0.id == attendance.trackstudent_id })
        }
        return attendances.isEmpty ? nil : attendances
    }
    
    // Get all attendances match the date
    var attendancesForDate: [Attendance]? {
        guard let attendancesForTrack = attendancesForTrack else { return nil }
        let attendances = attendancesForTrack.filter { $0.date.formatted(date: .long, time: .omitted) == selectedDate.formatted(date: .long, time: .omitted) }
        return attendances.isEmpty ? nil : attendances
    }

    // Get all attendances match the session
    var attendances: [Attendance]? {
        guard let attendancesForDate = attendancesForDate else { return nil }
        let filteredAttendances = attendancesForDate.filter { $0.sessionNumber == String(session) }
        return filteredAttendances.isEmpty ? nil : filteredAttendances
    }

    // Get all trackstudents match the attendances
    var trackstudents: [TrackStudent]? {
        guard let attendances = attendances else { return nil }
        let filteredTrackStudents = data.trackstudents.filter { trackstudent in
            attendances.contains(where: { $0.trackstudent_id == trackstudent.id })
        }
        return filteredTrackStudents.isEmpty ? nil : filteredTrackStudents
    }

    // Get all students match the trackstudents
    var students: [Student]? {
        guard let trackstudents = trackstudents else { return nil }
        let filteredStudents = data.students.filter { student in
            trackstudents.contains(where: { $0.student_id == student.id })
        }
        return filteredStudents.isEmpty ? nil : filteredStudents
    }

    var body: some View {
        List {
            Text(track.location)
            Text("Start Date: \(track.startDate)")
            Text("End Date: \(track.endDate)")
            ForEach(track.sessions.indices) { index in
                let session = track.sessions[index]
                VStack {
                    HStack {
                        Text("Session \(String(Character(UnicodeScalar(index + 65)!)).uppercased()) :")
                        Text(session)
                    }
                }
            }
            
            HStack {
                Image(systemName: "calendar")
                DatePicker("Select Date", selection: $selectedDate, in: startOfWeek...endOfWeek, displayedComponents: .date)
            }
            
            Picker("Session", selection: $session) {
                ForEach(track.sessions.indices) { index in
                    Text("Session \(String(Character(UnicodeScalar(index + 65)!)).uppercased()) ")
                }
            }
            Text("\(session)" as String)
            
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
            
            if let attendances = attendances {
                ForEach(attendances.indices) { index in
                    HStack {
                        if let students = students {
                            Text(students[index].name)
                        }
                        Spacer()
                        CheckInView(attendance: attendances[index])
                        Spacer()
                        CheckOutView(attendance: attendances[index])
                        Spacer()
                    }
                    
                    Text("\(attendances[index].date)" as String)
                    Text("\(attendances[index].date.formatted(date: .long, time: .omitted))" as String)
                    Text("")
                    Text("\(selectedDate)" as String)
                    Text("\(selectedDate.formatted(date: .long, time: .omitted))" as String)
                    
                }
                .onAppear {
                    self.data.readData()
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
