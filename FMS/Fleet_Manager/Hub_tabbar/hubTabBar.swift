//
//  hubPageui.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//

import SwiftUI
import FirebaseFirestore




struct hubTabBar: View {
    @State var users: [User] = []
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Vehicles Section
                    SectionHeader(title: "Vehicle", destination: ShowVehicleListView())
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



struct VehicleList: View {
    let vehicles = [
        Vehicle(
            type: .car,
            model: "Tesla Model 3",
            registrationNumber: "ABC1234",
            fuelType: .electric,
            mileage: 12000.5,
            rc: "RC123456789",
            vehicleImage: "Freightliner_M2_106_6x4_2014_(14240376744)",
            insurance: "Insured until 2026",
            pollution: "Euro 6",
            status: true),
        Vehicle(
            type: .car,
            model: "Tesla Model 3",
            registrationNumber: "ABC1234",
            fuelType: .electric,
            mileage: 12000.5,
            rc: "RC123456789",
            vehicleImage: "Freightliner_M2_106_6x4_2014_(14240376744)",
            insurance: "Insured until 2026",
            pollution: "Euro 6",
            status: true)
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
    var vehicle: Vehicle
    
    var body: some View {
        HStack(spacing: 12) {
            // Display vehicle image from URL
            AsyncImage(url: URL(string: vehicle.vehicleImage)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Color.gray
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.model)
                    .font(.headline)
                Text(vehicle.registrationNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    // Display status as a circle with color
                    Circle()
                        .fill(vehicle.status ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(vehicle.status ? "Active" : "Inactive")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()  // Add padding to make the card look nicer
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}


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
