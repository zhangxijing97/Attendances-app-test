//
//  StudentView.swift
//  AttendancesAppTest
//
//  Created by 张熙景 on 4/7/23.
//

import SwiftUI

struct StudentView: View {
    @ObservedObject var data: HTTPClient
    @State private var isPresented: Bool = false
    
    private func updateStudent(student: Student) {
        
        HTTPClient().updateStudent(student) { success in
            if success {
                print("Student updated successfully.")
            } else {
                print("Student update failed.")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Count: \(data.students.count)")
                ForEach(data.students, id: \.id) { student in
                    Text(student.name)
                }
                Button(action: {
                    
                }) {
                    Text("Update test")
                }
                .onTapGesture {
                    
                    let student = Student(id: data.students[0].id, referenceNumber: data.students[0].referenceNumber, name: data.students[0].name, gender: data.students[0].gender, emailAddress: data.students[0].emailAddress, phoneNumber: data.students[0].phoneNumber, parentName: "HHH", parentPhoneNumber: data.students[0].parentPhoneNumber, additionalContactPhoneNumber: data.students[0].additionalContactPhoneNumber)
                    
                    self.updateStudent(student: student)
                    
                }
            }
            .navigationTitle("Students")
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
            AddStudentView()
        })
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView(data: HTTPClient())
    }
}
