//
//  Home.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//

//import SwiftUI
//import FirebaseAuth
//
//struct HomeView: View {
//    
//    @State private var username: String = ""
//    @State private var isLoggedOut = false
//    
//    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define 2 flexible columns
//    let spacing: CGFloat = 20 // Adjust spacing between items
//   
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: spacing) {
//                    NavigationLink(destination: FindDoctor()) {
//                        CardView(title: "Find Doctor", iconName: "person.fill", gradientColors: [.blue, .purple])
//                    }
//
//                    NavigationLink(destination: LabTestActivity()) {
//                        CardView(title: "Lab Test", iconName: "eyedropper", gradientColors: [.green, .blue])
//                    }
//
//                    NavigationLink(destination: OrderDetailsView()) {
//                        CardView(title: "Order Details", iconName: "cart.fill", gradientColors: [.pink, .indigo])
//                    }
//
//                    NavigationLink(destination: MedicineView()) {
//                        CardView(title: "Buy Medicine", iconName: "bandage.fill", gradientColors: [.purple, .red])
//                    }
//
//                    NavigationLink(destination: healthArticlesView()) {
//                        CardView(title: "Health Articles", iconName: "book.fill", gradientColors: [.red, .orange])
//                    }
//                    
//                    Button(action: {
//                                            logout()
//                                        }) {
//                                            CardView(title: "Log out", iconName: "arrow.right.square", gradientColors: [.red, .blue])
//                                        }
//                    
//                }
//                .padding()
//            }
//            .navigationTitle("Healthcare")
//            .fullScreenCover(isPresented: $isLoggedOut) {
//                LoginView()
//        }
//        
//        
//}
//        
//        
//}
//    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            isLoggedOut = true
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//
//}
//
//struct CardView: View {
//    
//    @Environment(\.colorScheme) var colorScheme
//    let title: String
//    let iconName: String
//    let gradientColors: [Color]
//
//    var body: some View {
//        VStack {
//            Image(systemName: iconName)
//                .font(.system(size: 60))
//                .foregroundColor(.white)
//                .frame(width: 80, height: 80)
//                .padding()
//                .background(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
//                .shadow(radius: 5)
//                .cornerRadius(30)
//
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.primary)
//        }
//        .padding([.horizontal, .vertical], 20)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.secondary.opacity(colorScheme == .dark ? 0.3 : 0.1))
//        .cornerRadius(30)
//        
//    }
//    
//}
//
//
//
//
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            //.preferredColorScheme(.dark)
//    }
//}
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State private var username: String = ""
    @State private var isLoggedOut = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define 2 flexible columns
    let spacing: CGFloat = 20 // Adjust spacing between items
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    NavigationLink(destination: FindDoctor()) {
                        CardView(title: "Find Doctor", iconName: "person.fill", gradientColors: [.blue, .purple])
                    }

                    NavigationLink(destination: LabTestActivity()) {
                        CardView(title: "Lab Test", iconName: "eyedropper", gradientColors: [.green, .blue])
                    }

                    NavigationLink(destination: OrderDetailsView()) {
                        CardView(title: "Order Details", iconName: "cart.fill", gradientColors: [.pink, .indigo])
                    }

                    NavigationLink(destination: MedicineView()) {
                        CardView(title: "Buy Medicine", iconName: "bandage.fill", gradientColors: [.purple, .red])
                    }

                    NavigationLink(destination: healthArticlesView()) {
                        CardView(title: "Health Articles", iconName: "book.fill", gradientColors: [.red, .orange])
                    }
                    
                    // Button to join Zoom meeting
                    Button(action: joinZoomMeeting) {
                        CardView(title: "Join Zoom Meeting", iconName: "video.fill", gradientColors: [.yellow, .orange])
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
    
    // Function to handle joining Zoom meeting
    func joinZoomMeeting() {
        // Replace this with the URL for your Zoom meeting
        if let url = URL(string: "zoomus://") {
            UIApplication.shared.open(url)
        }
    }
}

struct CardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let iconName: String
    let gradientColors: [Color]

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                .shadow(radius: 5)
                .cornerRadius(30)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding([.horizontal, .vertical], 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary.opacity(colorScheme == .dark ? 0.3 : 0.1))
        .cornerRadius(30)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

