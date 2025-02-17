//
//  ProfileView.swift
//  Fleet Manager Profile
//
//  Created by Kushgra Grover on 13/02/25.
//

import SwiftUI
import FirebaseFirestore



//struct fleetProfileView: View {
//    
// 
//    if let userUUID = UserDefaults.standard.string(forKey: "loggedInUserUUID") {
//        
//        print("User UUID: \(userUUID)")
//        // Fetch user profile from Firestore
//        let db = Firestore.firestore()
//        db.collection("users").document(userUUID).getDocument { (document, error) in
//            if let document = document, document.exists {
//                let userData = document.data()
//                print("User Profile: \(userData ?? [:])")
//                
//                
//            } else {
//                print("User not found")
//            }
//        }
//    }
//        
//    var body: some View {
//        NavigationView{
//            VStack {
//                // Profile Image
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.blue)
//                    .padding(.top, 20)
//                
//                // Name
//                Text("John Anderson")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.top, 8)
//                
//                // Contact Info Card
//                ContactInfoCard()
//                    .padding()
//                
//                // Logout Button
//                Button(action: {
//                    print("Logout button tapped")
//                }) {
//                    Text("Log Out")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.red)
//                        .cornerRadius(10)
//                        .padding(.horizontal, 20)
//                }
//                .padding(.top, 20)
//                
//                Spacer()
//            }
//            .navigationBarTitle("Profile", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                print("Edit button tapped")
//            }) {
//                Image(systemName: "pencil")
//            })
//        }
//    }
//}


struct FleetProfileView: View {
    @State private var userData: [String: Any] = [:]
    @State private var userUUID: String? = UserDefaults.standard.string(forKey: "loggedInUserUUID")

    var body: some View {
        NavigationView {
            VStack {
                // Profile Image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // Name
                Text(userData["name"] as? String ?? "John Anderson") // Replace with dynamic name
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                // Contact Info Card
                ContactInfoCard()
                    .padding()
                
                // Logout Button
                Button(action: {
                    logoutUser()
                }) {
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Edit button tapped")
            }) {
                Image(systemName: "pencil")
            })
            .onAppear {
                fetchUserProfile()
            }
        }
    }

    func fetchUserProfile() {
        guard let userUUID = userUUID else {
            print("No user UUID found")
            return
        }
        
        print("User UUID: \(userUUID)")
        let db = Firestore.firestore()
        db.collection("users").document(userUUID).getDocument { (document, error) in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self.userData = document.data() ?? [:]
                }
            } else {
                print("User not found")
            }
        }
    }
    
    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "loggedInUserUUID")
        print("User logged out")
    }
}

struct ContactInfoCard: View {
    
    @State private var userData: [String: Any] = [:]
    @State private var userUUID: String? = UserDefaults.standard.string(forKey: "loggedInUserUUID")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Information")
                .font(.headline)
                .fontWeight(.bold)

            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                Text(userData["phone"] as? String ?? "John Anderson")
            }

            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                Text(userData["email"] as? String ?? "John Anderson")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onAppear {
            fetchUserProfile()
        }
    }
    
    func fetchUserProfile() {
        guard let userUUID = userUUID else {
            print("No user UUID found")
            return
        }
        
        print("User UUID: \(userUUID)")
        let db = Firestore.firestore()
        db.collection("users").document(userUUID).getDocument { (document, error) in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self.userData = document.data() ?? [:]
                }
            } else {
                print("User not found")
            }
        }
    }
}
#Preview {
    FleetProfileView()
}
