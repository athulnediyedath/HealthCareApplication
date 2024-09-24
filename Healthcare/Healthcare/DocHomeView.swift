//
//  DocHomeView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 14/03/24.
//

import SwiftUI
import FirebaseAuth

struct DocHomeView: View {
    
    @State private var username: String = ""
    @State private var isLoggedOut = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define 2 flexible columns
    let spacing: CGFloat = 20 // Adjust spacing between items
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    NavigationLink(destination: Schedules()) {
                        CardView(title: "Schedule", iconName: "person.fill", gradientColors: [.blue, .purple])
                    }

                    NavigationLink(destination: LabTestActivity()) {
                        CardView(title: "Users", iconName: "eyedropper", gradientColors: [.green, .blue])
                    }
                    NavigationLink(destination: CreateMeetingView()) {
                        CardView(title: "Users", iconName: "video.circle", gradientColors: [.green, .blue])
                    }

                   
                    
                    Button(action: {
                                            logout()
                                        }) {
                                            CardView(title: "Log out", iconName: "arrow.right.square", gradientColors: [.red, .blue])
                                        }
                    
                }
                .padding()
            }
            .navigationTitle("Healthcare")
            .fullScreenCover(isPresented: $isLoggedOut) {
         LoginView()
        }
            
           
        
}
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
}

struct Schedules: View {
    var body: some View {
        Text("Schedules")
    }
}


#Preview {
    DocHomeView()
}
