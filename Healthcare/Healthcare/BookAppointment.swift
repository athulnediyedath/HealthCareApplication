//
//  BookAppointmentActivity.swift
//  HealthCare
//
//  Created by Athul Sasikumar on 14/03/24.
//

import Foundation
import SwiftUI

import SwiftUI
import Firebase

struct BookAppointmentView: View {
    @State private var fullName = ""
    @State private var address = ""
    @State private var contactNumber = ""
    @State private var fees = "1500RS"
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
    @State private var isAppointmentBooked = false
    @Environment(\.presentationMode) var presentationMode
    
    var title: String
    var appointmentTitle: String
    var backButtonAction: () -> Void
    var bookAppointmentAction: () -> Void
    var userEmail: String? {
        return Auth.auth().currentUser?.email
    }
    var doctorName: String // Add doctorName property
        var specialty: String
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Contact Number", text: $contactNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Fees", text: $fees)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Date")
                    .font(.headline)
                DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Time")
                    .font(.headline)
                DatePicker("", selection: $selectedTime, in: Date()..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            HStack {
                Button(action: {
                    // Save appointment details to Firestore
                    saveAppointmentToFirestore()
                    
                    self.presentationMode.wrappedValue.dismiss()
                    isAppointmentBooked = true
                    
                    // Perform any other actions after booking appointment
                    bookAppointmentAction()
                }) {
                    Text("Book Appointment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: backButtonAction) {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .alert(isPresented: $isAppointmentBooked) {
                       Alert(title: Text("Appointment Booked"), message: Text("Your appointment has been successfully booked."), dismissButton: .default(Text("OK")))
                   }
        .background(
            NavigationLink(destination: {}, label: {})
        )
       }
    
    func saveAppointmentToFirestore() {
        // Create a new appointment document in Firestore
        let appointmentData: [String: Any] = [
            "fullName": fullName,
            "address": address,
            "contactNumber": contactNumber,
            "fees": fees,
            "selectedDate": selectedDate,
            "selectedTime": selectedTime,
            "userEmail": userEmail as Any,
            "doctorName": doctorName,
            "specialty": specialty
        ]
        
        // Add a new document with a generated ID to the "Appointments" collection
        db.collection("Appointments").addDocument(data: appointmentData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Appointment details saved successfully.")
            }
        }
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(
            title: "Book Appointment",
            appointmentTitle: "Dentist",
            backButtonAction: {},
            bookAppointmentAction: {},
            doctorName: "Dr. John Doe",
            specialty: "Dentistry"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

