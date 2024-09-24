//
//  Register.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var phoneno: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var isDoctor: Bool = false
    @State private var alertMessage = ""
    @State private var address: String = ""
    @State private var specialty: String = ""
    @State private var isRegistered = false

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("+91 ", text: $phoneno)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Toggle("Register as Doctor", isOn: $isDoctor)
                .padding()
            
            if isDoctor {
                TextField("Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Specialty", text: $specialty)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Button(action: {
                register()
            }) {
                Text("Register")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .padding()
        .navigationBarTitle("Register")
        .fullScreenCover(isPresented: $isRegistered) {
            if isDoctor {
                DocHomeView()
            } else {
                HomeView()
            }
        }
    }

    func register() {
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert = true
            alertMessage = "Please fill in all fields"
            return
        }

        if password != confirmPassword {
            showAlert = true
            alertMessage = "Password and Confirm Password didn't match"
            return
        }

        // Register logic based on user type
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                // Registration successful, proceed to store additional user data
                if isDoctor {
                    // Register as a doctor
                    let doctorData = [
                        "username": username,
                        "email": email,
                        "address": address,
                        "+Phone No": phoneno,
                        "specialty": specialty
                        // Add more fields as needed
                    ]

                    // Store doctor data in Firestore collection for doctors
                    let db = Firestore.firestore()
                    db.collection("Doctors").document(authResult!.user.uid).setData(doctorData) { error in
                        if let error = error {
                            print("Error registering as a doctor: \(error.localizedDescription)")
                        } else {
                            print("Successfully registered as a doctor")
                        }
                    }
                } else {
                    // Register as a regular user
                    let userData = [
                        "username": username,
                        "email": email,
                        "+91": phoneno,
                        "Password": password
                        
                    ]

                    // Store user data in Firestore collection for users
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData(userData) { error in
                        if let error = error {
                            print("Error registering as a user: \(error.localizedDescription)")
                        } else {
                            print("Successfully registered as a user")
                        }
                    }
                }
                isRegistered = true
            }
        }
    }

}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
