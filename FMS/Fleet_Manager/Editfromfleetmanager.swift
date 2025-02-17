//
//  editfromfleetmanager.swift
//  FMS
//
//  Created by Ankush Sharma on 17/02/25.
//

import SwiftUI
import FirebaseFirestore
struct editfromfleetmanager: View {
    @Binding var userData: [String: Any]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var contact: String = ""
    @State private var userUUID: String? = UserDefaults.standard.string(forKey: "loggedInUserUUID")
    
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name").font(.headline).padding(.leading, -22)) {
                    TextField("Enter your name", text: $name)
                        .padding(5)
                        .background(Color.clear)
                        .frame(height: 47)
                        .listRowBackground(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .frame(width: 361)
                }
                
                Section(header: Text("Email").font(.headline).padding(.leading, -22)) {
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(5)
                        .background(Color.clear)
                        .frame(height: 47)
                        .listRowBackground(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .frame(width: 361)
                        .disabled(true)  // Email is typically non-editable
                }
                
                Section(header: Text("Contact Number").font(.headline).padding(.leading, -22)) {
                    TextField("Enter contact number", text: $contact)
                        .keyboardType(.phonePad)
                        .padding(5)
                        .background(Color.clear)
                        .frame(height: 47)
                        .listRowBackground(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .frame(width: 361)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()  // Dismiss on cancel
                },
                trailing: Button("Save") {
                    saveUserData()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                loadUserData()
            }
        }
    }
    
    private func loadUserData() {
        name = userData["name"] as? String ?? ""
        email = userData["email"] as? String ?? ""
        contact = userData["phone"] as? String ?? ""
    }

    private func saveUserData() {
        userData["name"] = name
        userData["phone"] = contact
        updateFleetManagerDetails()
    }
    private func updateFleetManagerDetails() {
//        guard let userId = user.id else { return }

        let driverData: [String: Any] = [
            "name": name,
            "email": email,
           "phone": contact,
//            "licenseNumber": licenseNumber,
//            "selectedVehicle": selectedVehicle,
//            "selectedTerrain": selectedTerrain
        ]

        db.collection("users").document(userUUID!).updateData(driverData) { error in
            if let error = error {
                print("Error updating driver details: \(error.localizedDescription)")
            } else {
                print("Driver details updated successfully")
            }
        }
    }
}

// MARK: - Preview with Mock Data
#Preview {
    editfromfleetmanager(userData: .constant([
        "name": "John Doe",
        "email": "johndoe@example.com",
        "phone": "1234567890"
    ]))

}
