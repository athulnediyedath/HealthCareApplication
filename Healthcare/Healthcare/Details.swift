import SwiftUI
import Firebase

struct AppointmentDetails: Identifiable {
    let id: String
    let fullName: String
    let doctorName: String
    let specialty: String
    let selectedDate: Date
    let selectedTime: Date
}

struct OrderDetailsView: View {
    @State private var appointmentDetails: [AppointmentDetails] = []
    @State private var isLoading = false
    @State private var searchText: String = ""
    
    var filteredAppointments: [AppointmentDetails] {
        if searchText.isEmpty {
            return appointmentDetails
        } else {
            return appointmentDetails.filter { appointment in
                appointment.doctorName.localizedCaseInsensitiveContains(searchText) ||
                appointment.specialty.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredAppointments) { appointment in
            AppointmentView(appointmentDetails: appointment)
                .padding(.vertical, 20)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by doctor name or specialty")
        .onAppear {
            fetchAppointmentDetails()
        }
    }
    
    func fetchAppointmentDetails() {
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("Appointments")
            .getDocuments { querySnapshot, error in
                defer {
                    isLoading = false
                }
                if let error = error {
                    print("Error fetching appointment details: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                appointmentDetails = documents.compactMap { document in
                    if let doctorName = document["doctorName"] as? String,
                       let fullName = document["fullName"] as? String,
                       let selectedDateTimestamp = document["selectedDate"] as? Timestamp,
                       let selectedTimeTimestamp = document["selectedTime"] as? Timestamp {
                        
                        let selectedDate = selectedDateTimestamp.dateValue()
                        let selectedTime = selectedTimeTimestamp.dateValue()
                        
                        return AppointmentDetails(id: document.documentID,
                                                  fullName: fullName,
                                                  doctorName: doctorName,
                                                  specialty: "",
                                                  selectedDate: selectedDate,
                                                  selectedTime: selectedTime)
                    } else {
                        return nil
                    }
                }
                
                if appointmentDetails.isEmpty {
                    print("No appointments found.")
                }
            }
    }
}

struct AppointmentView: View {
    let appointmentDetails: AppointmentDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full Name: \(appointmentDetails.fullName)")
            Text("Doctor Name: \(appointmentDetails.doctorName)")
            Text("Specialty: \(appointmentDetails.specialty)")
            Text("Date: \(formattedDate)")
            Text("Time: \(formattedTime)")
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: appointmentDetails.selectedDate)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: appointmentDetails.selectedTime)
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
