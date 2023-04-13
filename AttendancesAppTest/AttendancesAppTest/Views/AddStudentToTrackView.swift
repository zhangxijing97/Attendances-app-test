//
//  AddStudentToTrackView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/8/23.
//

import SwiftUI

struct AddStudentToTrackView: View {
    @ObservedObject var data: HTTPClient
    var track: Track
    @Binding var dismiss: Bool // For dismiss
    
    var students: [Student] {
        let students = data.getStudentsForTrack(data: data, track: track)
        return students
    }
    
    var sessions: [Session] {
        let sessions = data.getSessionsForTrack(data: data, track: track)
        return sessions
    }
    
    var studentsForTrack: [Student] {
        let students = data.getStudentsForTrack(data: data, track: track)
        return students
    }
    
    private func createTrackStudent(student: Student) {
        let trackStudent = TrackStudent(id: UUID(), track_id: track.id, student_id: student.id)
        
        HTTPClient().createTrackStudent(id: trackStudent.id, track_id: track.id, student_id: student.id) { success in
            if success {
                print("TrackStudent create successfully")
                createAttendances(trackstudent_id: trackStudent.id)
            } else {
                // show user the error message that save was not successful
                print("Failed to create TrackStudent")
            }
        }
    }
    
    private func createAttendances(trackstudent_id: UUID) {
        let checkInTime = Date(timeIntervalSince1970: 0)
        let checkOutTime = Date(timeIntervalSince1970: 0)
        for session in sessions {
            HTTPClient().createAttendance(trackstudent_id: trackstudent_id, date: session.date, sessionNumber: session.sessionNumber, checkInTime: checkInTime, checkOutTime: checkOutTime) { success in
                if success {
                    print("Attendance create successfully")
                } else {
                    // show user the error message that save was not successful
                    print("Failed to create Attendance")
                }
            }
        }
    }
    
    private func removeTrackStudent(student: Student) {
        guard let trackStudent = data.getTrackStudentForTrackAndStudent(data: data, track: track, student: student) else {
            return
        }
        HTTPClient().deleteTrackStudent(trackstudent: trackStudent) { success in
            if success {
                print("TrackStudent delete successfully")
                removeAttendances(trackstudent_id: trackStudent.id)
            } else {
                // show user the error message that delete was not successful
                print("Failed to delete TrackStudent")
            }
        }
    }
    
    private func removeAttendances(trackstudent_id: UUID) {
        
        let attendances = data.attendances.filter { $0.trackstudent_id == trackstudent_id }
        for attendance in attendances {
            HTTPClient().deleteAttendance(attendance: attendance) { success in
                if success {
                    print("Attendance delete successfully")
                } else {
                    print("Failed to delete Attendance")
                }
            }
        }
    }
    
    var body: some View {
        List {
            Text("All students added to the Track").bold() // For testing
            ForEach(students) { student in
                HStack {
                    Text(student.name)
                }
            }
            
            Text("All Students").bold()
            ForEach(data.students.indices, id: \.self) { index in
                let student = data.students[index]
                HStack {
                    Text(student.name)
                    Spacer()
                    
                    Button(action: {
                        if data.getTrackStudentForTrackAndStudent(data: data, track: track, student: student) != nil {
                            // Remove the student from the track
                            self.removeTrackStudent(student: student)
                            
                        } else {
                            // Add the student to the track
                            self.createTrackStudent(student: student)
                        }
                    }) {
                        if data.getTrackStudentForTrackAndStudent(data: data, track: track, student: student) != nil {
                            Text("Remove")
                                .foregroundColor(.red)
                        } else {
                            Text("Add")
                        }
                    }
                     
                }
            }
        }
        
    }
}

struct AddStudentToTrackView_Previews: PreviewProvider {
    static var previews: some View {
        let track = Track.example
        AddStudentToTrackView(data: HTTPClient(), track: track, dismiss: .constant(false))
    }
}
