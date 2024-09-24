//
//  ContentView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false // Track login state

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()

                NavigationLink(destination: RegisterView()) {
                    Text("New User? Register Here")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
            .navigationBarTitle("Login")
            .fullScreenCover(isPresented: $isLoggedIn) {
                if UserDefaults.standard.bool(forKey: "isDoctor") {
                    DocHomeView()
                } else {
                    HomeView() // Show HomeView for regular users
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func login() {
        if email.isEmpty || password.isEmpty {
            showAlert = true
            alertMessage = "Please fill in all fields"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else if let uid = result?.user.uid {
                let db = Firestore.firestore()
                db.collection("Doctors").document(uid).getDocument { snapshot, error in
                    if let snapshot = snapshot, snapshot.exists {
                        // User is a doctor
                        UserDefaults.standard.set(true, forKey: "isDoctor")
                    } else {
                        // User is not a user
                        UserDefaults.standard.set(false, forKey: "isDoctor")
                    }
                    isLoggedIn = true
                }
            } else {
                showAlert = true
                alertMessage = "Unexpected error occurred. Please try again."
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
