//
//  ProfileView.swift
//  Fleet Manager Profile
//
//  Created by Kushgra Grover on 13/02/25.
//

//import SwiftUI
//import FirebaseFirestore



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


import SwiftUI
import FirebaseFirestore

struct FleetProfileView: View {
    @State private var userData: [String: Any] = [:]
    @State private var userUUID: String? = UserDefaults.standard.string(forKey: "loggedInUserUUID")
    @State private var isEditing = false
    @State private var animateEditIcon = false
    
    @State private var showAlert: Bool = false
    @State private var showEditView = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .shadow(radius: 5)
                        .padding(.top, 40)
                    
                    Text(userData["name"] as? String ?? "John Anderson")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .background(isEditing ? Color.white : Color.clear)
                        .cornerRadius(8)
                        .shadow(radius: isEditing ? 2 : 0)
                        .overlay(
                            TextField("Enter Name", text: Binding(
                                get: { userData["name"] as? String ?? "" },
                                set: { userData["name"] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 300)
                            .opacity(isEditing ? 1 : 0)
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                ContactInfoCard(isEditing: $isEditing, userData: $userData)
                    .padding()
                
                Button(action: logoutUser) {
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .shadow(radius: 3)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .navigationBarTitle("Profile")
           
            .navigationBarItems(
                    trailing: Button("Edit") {
                        showEditView.toggle()
                    }
                )
                .sheet(isPresented: $showEditView) {
                    editfromfleetmanager(userData: $userData)
                }
            
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
    @Binding var isEditing: Bool
    @Binding var userData: [String: Any]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Information")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                TextField("Enter Phone", text: Binding(
                    get: { userData["phone"] as? String ?? "8235205048" },
                    set: { userData["phone"] = $0 }
                ))
//                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(8)
                .disabled(!isEditing)
//                .shadow(radius: 2)
            }
            .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                Text(userData["email"] as? String ?? "raj@gmail.com") // Email remains uneditable
            }
            .padding(.vertical, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    FleetProfileView()
}
