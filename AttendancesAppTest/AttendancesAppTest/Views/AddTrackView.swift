//
//  AddTrackView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 3/27/23.
//

import SwiftUI

struct AddTrackView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Track X"
    @State private var level = "Grades 6-9"
    @State private var location = "ASU Mesa MIX Center"
    
    @State private var startDate = Date()
//    @State private var startDate: Date = {
//        let timeZone = TimeZone(identifier: "UTC")!
//        let calendar = Calendar(identifier: .gregorian)
//        let now = Date()
//        let components = calendar.dateComponents(in: timeZone, from: now)
//        return calendar.date(from: components)!
//    }()
    
    
    @State private var numberOfDays = 4
    private var endDate: Date {
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: startDate)!
        
//        let timeZone = TimeZone(identifier: "America/Phoenix")!
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents(in: timeZone, from: startDate)
//        let newComponents = DateComponents(year: components.year, month: components.month, day: components.day! + numberOfDays)
//        return calendar.date(from: newComponents)!
    }
    @State private var numberOfSessions = 1
    
    //  Properties for create session
    @State private var sessions: [String] = [""]
    @State private var startTimes: [Date] = [Date()]
    @State private var endTimes: [Date] = [Date()]
    
    // Function for updating sessions when the numberOfSessions changed by user
    private func updateSessions() {
        let currentCount = sessions.count
        let newCount = numberOfSessions
        if currentCount < newCount {
            sessions.append(contentsOf: Array(repeating: "", count: newCount - currentCount))
            startTimes.append(contentsOf: Array(repeating: Date(), count: newCount - currentCount))
            endTimes.append(contentsOf: Array(repeating: Date(), count: newCount - currentCount))
        } else if currentCount > newCount {
            sessions.removeLast(currentCount - newCount)
            startTimes.removeLast(currentCount - newCount)
            endTimes.removeLast(currentCount - newCount)
        }
    }
    
    // Function for get date range from startDate to endDate, return all [Date] of range
    private func dateRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dateRange: [Date] = []
        var currentDate = startDate
        while currentDate <= endDate {
            dateRange.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dateRange
    }
    
    // Function for combining two Date, get one Date part and get one time part
    func combine(date: Date, time: Date) -> Date {
//        let calendar = Calendar.current
//        let timeZone = TimeZone(identifier: "America/Phoenix")!
        let calendar = Calendar(identifier: .gregorian)
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second
//        combinedComponents.timeZone = timeZone
        
        return calendar.date(from: combinedComponents)!
    }
    
    private func createTrack() {
        let track = Track(id: UUID(), name: self.name, level: self.level, location: self.level, startDate: self.startDate, endDate: self.endDate, sessions: self.sessions)
        
        HTTPClient().createTrack(id: track.id, name: track.name, level: track.level, location: track.location, startDate: track.startDate, endDate: track.endDate, sessions: track.sessions) { success in
            if success {
                // close the modal
                print("Track create successfully")
                createSessions(track: track)
            } else {
                // show user the error message that save was not successful
                print("Failed to create track")
            }
        }
    }
        
    private func createSessions(track: Track) {
        let sessionCount = self.sessions.count
        let dateRange = self.dateRange(from: self.startDate, to: self.endDate)

        for index in track.sessions.indices {
            let session = track.sessions[index]
            
            for dateIndex in dateRange.indices {
                let date = dateRange[dateIndex]
                HTTPClient().createSession(track_id: track.id, sessionNumber: String(index), date: date, startTime: combine(date: date, time: self.startTimes[index]), endTime: combine(date: date, time: self.endTimes[index])) { success in
                    if success {
                        print("Session create successfully")
                    } else {
                        // show user the error message that save was not successful
                        print("Failed to create Session")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                TextField("Name", text: $name)
                TextField("Level", text: $level)
                TextField("Location", text: $location)
                
                // The View to select startDate and endDate
                VStack {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: [.date]
                    )

                    Stepper(
                        value: $numberOfDays,
                        in: 1...365,
                        label: { Text("Number of Days: \(numberOfDays + 1)") }
                    )

                    DatePicker(
                        "End Date",
                        selection: Binding<Date>(
                            get: { endDate },
                            set: { newEndDate in
                                numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: newEndDate).day!
                            }
                        ),
                        displayedComponents: [.date]
                    )
                }
                Stepper(
                    value: $numberOfSessions,
                    in: 1...10,
                    label: { Text("Number of Sessions: \(numberOfSessions)") }
                )
                .onChange(of: numberOfSessions) { _ in
                    updateSessions()
                }
                
                ForEach(sessions.indices, id: \.self) { index in
                    VStack {
                        TextField("Session \(index + 1)", text: $sessions[index])
                        DatePicker(
                            "Start Date",
                            selection: $startTimes[index],
                            displayedComponents: [.hourAndMinute]
                        )
                        
                        DatePicker(
                            "End Date",
                            selection: $endTimes[index],
                            displayedComponents: [.hourAndMinute]
                        )
                    }
                }
                
            }
            .navigationTitle("Add new Track")
            .toolbar {
                Button("Save") {
                    self.createTrack()
                    HTTPClient().readData()
                    dismiss()
                }
            }
        }
    }
}

struct AddTrackView_Previews: PreviewProvider {
    static var previews: some View {
        AddTrackView()
    }
}

