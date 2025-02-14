//
//  hubPageui.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//
import SwiftUI
//------------------------------------------------
//------------------------------------------------
    //Example struct 
struct Vehicle3: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let status: String
    let image: UIImage
    let statusColor: Color
}

struct Driver3: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    let status: String
    let statusColor: Color
}
//------------------------------------------------
//------------------------------------------------

struct hubTabBar: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    HStack {
                        Text("Vehicle")
                            .font(.system(size: 19.5))
                            .bold()
                        Spacer()
                        VStack {
                            NavigationLink(destination:VehicleListView()
                                .navigationTitle("Vehicle")
                                .navigationBarTitleDisplayMode(.inline)
                                           
                            ){
                                Text("View All")
                                    .font(.system(size: 17))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    VehicleList()
                    
                    HStack {
                        Text("Drivers")
                            .font(.system(size: 19.5))
                            .bold()
                        Spacer()
                        NavigationLink(destination:DriverListView())
                        {
                            Text("View All")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    DriverList()
                    
                    HStack {
                        Text("Maintenance Personel")
                            .font(.system(size: 19.5))
                            .bold()
                        Spacer()
                        NavigationLink(destination:MaintenanceListView())
                        {
                            Text("View All")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color(.systemGray6))
            .navigationTitle("HUB")
            .onAppear {
                UINavigationBar.appearance().backgroundColor = .white
                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().isTranslucent = false
            }
            
        }
    }
}
//
//struct SectionHeader: View {
//    var title: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.headline)
//                .bold()
//            Spacer()
//            NavigationLink(destination:VehicleListView())
//            {
//                Text("View All")
//                    .font(.caption)
//                    .foregroundColor(.blue)
//            }
//        }
//        .padding(.horizontal)
//    }
//}

struct VehicleList: View {
    let vehicles = [
        Vehicle3(name: "Bharat Benz 2019", number: "PB 62 AB 0987", status: "Active",  image: UIImage(named: "Freightliner_M2_106_6x4_2014_(14240376744)") ?? UIImage(), statusColor: .green),
        Vehicle3(name: "Bharat Benz 2020", number: "PB 62 AB 0001", status: "Maintenance", image: UIImage(named: "Freightliner_M2_106_6x4_2014_(14240376744)") ?? UIImage(), statusColor: .yellow)
    ]
    
    var body: some View {
        VStack {
            ForEach(vehicles) { Vehicle3 in
                VehicleCard(Vehicle3: Vehicle3)
            }
        }
        .padding(.horizontal)
    }
}

struct VehicleCard: View {
    var Vehicle3: Vehicle3
    
    var body: some View {
        HStack(spacing: 12) {
            Image(uiImage: Vehicle3.image)  // Use Image(uiImage:) for UIImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            
            VStack(alignment: .leading, spacing: 4) {
                Text(Vehicle3.name)
                    .font(.headline)
                Text(Vehicle3.number)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Circle()
                        .fill(Vehicle3.statusColor)
                        .frame(width: 8, height: 8)
                    Text(Vehicle3.status)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

struct DriverList: View {
    let drivers = [
        Driver3(name: "Ram Prasad", phone: "+91 7635467832", status: "Available", statusColor: .green),
        Driver3(name: "Viren Sharma", phone: "+91 7635467832", status: "On Trip", statusColor: .yellow),
        Driver3(name: "Viren Sharma", phone: "+91 7635467832", status: "On Trip", statusColor: .yellow),
        Driver3(name: "Viren Sharma", phone: "+91 7635467832", status: "On Trip", statusColor: .yellow)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(drivers) { Driver3 in
                    DriverCard(Driver3: Driver3)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DriverCard: View {
    var Driver3: Driver3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                
                VStack(alignment: .leading) {
                    Text(Driver3.name)
                        .font(.headline)
                    Text(Driver3.phone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
//            .padding(.top,-50)
            
            HStack {
                Circle()
                    .fill(Driver3.statusColor)
                    .frame(width: 8, height: 8)
                Text(Driver3.status)
                    .font(.caption)
                    .foregroundColor(.gray)
            }.padding(.top,20)
        }
//        .padding()
        .frame(width: 200,height:120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}



#Preview {
    hubTabBar()
}
