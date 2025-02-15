//
//  hubPageui.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//

import SwiftUI
import FirebaseFirestore

//------------------------------------------------
// Example Structs
//------------------------------------------------

struct Vehicle3: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let status: String
    let image: UIImage
    let statusColor: Color
}


//------------------------------------------------
// Main View
//------------------------------------------------

struct hubTabBar: View {
    @State var users: [User] = []
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Vehicles Section
                    SectionHeader(title: "Vehicle", destination: VehicleListView())
                    VehicleList()
                    
                    // Drivers Section
                    SectionHeader(title: "Drivers", destination: DriverListView()
)
                    DriverList(filteredUsers: users)
                    
                    // Maintenance Personnel Section
                    SectionHeader(title: "Maintenance Personnel", destination: MaintenanceListView())
                    MaintenancePersonnelLists()
//                    MaintenancePersonnelListView()
                
//                    MaintenancePersonnelListview()
                }
                .padding(.top)
            }
            .background(Color(.systemGray6))
            .navigationTitle("HUB")
            .onAppear {
                UINavigationBar.appearance().backgroundColor = .white
                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().isTranslucent = false
                fetchUsersDriver()
            }
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
}

//------------------------------------------------
// Section Header Component
//------------------------------------------------

struct SectionHeader<Destination: View>: View {
    var title: String
    var destination: Destination
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 19.5))
                .bold()
            Spacer()
            NavigationLink(destination: destination) {
                Text("View All")
                    .font(.system(size: 17))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}

//------------------------------------------------
// Vehicle List Component
//------------------------------------------------

struct VehicleList: View {
    let vehicles = [
        Vehicle3(name: "Bharat Benz 2019", number: "PB 62 AB 0987", status: "Active", image: UIImage(named: "Freightliner_M2_106_6x4_2014_(14240376744)") ?? UIImage(), statusColor: .green),
        Vehicle3(name: "Bharat Benz 2020", number: "PB 62 AB 0001", status: "Maintenance", image: UIImage(named: "Freightliner_M2_106_6x4_2014_(14240376744)") ?? UIImage(), statusColor: .yellow)
    ]
    
    var body: some View {
        VStack {
            ForEach(vehicles) { vehicle in
                VehicleCard(vehicle: vehicle)
            }
        }
        .padding(.horizontal)
    }
}

struct VehicleCard: View {
    var vehicle: Vehicle3
    
    var body: some View {
        HStack(spacing: 12) {
            Image(uiImage: vehicle.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.name)
                    .font(.headline)
                Text(vehicle.number)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Circle()
                        .fill(vehicle.statusColor)
                        .frame(width: 8, height: 8)
                    Text(vehicle.status)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

//------------------------------------------------
// Driver List Component
//------------------------------------------------

struct DriverList: View {
    var filteredUsers: [User]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filteredUsers) { user in
                    DriverCard(user: user)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DriverCard: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.leading,-20)
                    .padding(.top,-25)
                
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.title3)
                       
                      
                    Text(user.phone)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.top,-27)
                .padding(.leading,10)
                .padding(.trailing,-15)
            }.padding(.top,40)
            
            HStack {
                Circle()
//                    .fill(user.statusColor)
                    .frame(width: 8, height: 8)
                Text(user.name)
                    .font(.caption)
                    .foregroundColor(.gray)
            }.padding(.top,20)
                .padding(.leading,-30)
        }
        .frame(width: 200, height: 120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

//------------------------------------------------
// Preview
//------------------------------------------------

struct MaintenancePersonnelLists: View {
    @State private var maintenanceList = [
        MaintenancePerson(name: "Ram Prasad", email: "john.anderson@example.com"),
        MaintenancePerson(name: "Sham Prasad", email: "sham.anderson@example.com"),
        MaintenancePerson(name: "Raam Prasad", email: "raam.anderson@example.com")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(maintenanceList) { person in
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.gray)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            Text(person.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .onDelete(perform: deletePerson)
            }
            
        }
    }

    private func deletePerson(at offsets: IndexSet) {
        maintenanceList.remove(atOffsets: offsets)
    }
}


#Preview {
    hubTabBar()
}
