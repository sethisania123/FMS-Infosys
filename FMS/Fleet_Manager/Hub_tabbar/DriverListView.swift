//
//  MaintenancePersonnel.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//

import SwiftUI
import FirebaseFirestore

struct DriverListView: View {
    @State private var searchText = ""
    @State var users: [User] = []
    @State private var showAlert = false
    @State private var userToDelete: User?

    let db = Firestore.firestore()

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 20)

                List {
                    ForEach(filteredUsers, id: \.id) { user in
                        NavigationLink(destination: DriverDetails(user: user)) {
                            DriverRow(user: user)
                        }
                    }
                    .onDelete(perform: confirmDelete)
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top, 30)
            .onAppear(perform: fetchUsersDriver)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this driver?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let user = userToDelete {
                            deleteUser(user)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Drivers")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func fetchUsersDriver() {
        db.collection("users").whereField("role", isEqualTo: "Driver").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.users = documents.compactMap { doc in
                let user = try? doc.data(as: User.self)
                return user?.id != nil ? user : nil
            }
        }
    }

    func confirmDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            userToDelete = users[index]
            showAlert = true
        }
    }

    func deleteUser(_ user: User) {
        db.collection("users").document(user.id ?? "").delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == user.id }
                }
            }
        }
    }
}

struct DriverRow: View {
    let user: User

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .foregroundColor(.black)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 5) {
                Text(user.name)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)

                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("Experience: \(user.name)")
                    .font(.footnote)
                    .foregroundColor(.black)

                Text("Terrain specialization: \(user.name)")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .frame(height: 100)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    DriverListView()
}
