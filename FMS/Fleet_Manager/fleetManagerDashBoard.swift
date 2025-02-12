//
//  FleetManagerDashboard.swift
//  FMS
//
//  Created by Ankush Sharma on 11/02/25.
//

import SwiftUI

struct FleetControlDashboard: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("List View")
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            Text("Map View")
                .tabItem {
                    Label("Trips", systemImage: "map.fill")
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .navigationTitle("Fleet Control")
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Grid of Info Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        InfoCard(icon: "truck.box.fill", value: "48", title: "Total Vehicles", color: .blue)
                        InfoCard(icon: "map.fill", value: "23", title: "Active Trips", color: .green)
                        InfoCard(icon: "person.3.fill", value: "32", title: "Maintenance Personnel", color: .purple)
                        InfoCard(icon: "person.crop.circle.fill", value: "45", title: "Total Drivers", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions Section
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        ActionButton(icon: "map", title: "Create Trip", color: .blue)
                        ActionButton(icon: "truck.box.fill", title: "Add Vehicle", color: .blue)
                        NavigationLink(destination: AddUserForm()) {
                            ActionButton(icon: "person.badge.plus", title: "Add User", color: .purple)
                        }
                    }
                    .padding(.horizontal)
                    HStack {
                    Text("Recent Activities")
                        .font(.headline)
                        .padding(.horizontal)
                   
                        Spacer().frame(minWidth: 100, maxWidth: 120)
                        Text("See all")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    // Recent Activities Section
                   
//                                            VStack(spacing: 8) {
//                                                ActivityCard(icon: "car.fill", title: "New vehicle added", subtitle: "Tesla Model 3 - ABC123", time: "2m ago")
//                                                ActivityCard(icon: "location.fill", title: "Trip started", subtitle: "Route: NYC to Boston", time: "15m ago")
//                                                ActivityCard(icon: "wrench.fill", title: "Maintenance alert", subtitle: "Vehicle XYZ789 needs service", time: "1h ago")
//                                                ActivityCard(icon: "person.fill.checkmark", title: "Driver assigned", subtitle: "John Doe - Route #123", time: "2h ago")
//                                            }
//                                            .padding(.horizontal)
                }
                .padding(.vertical)
               
                
                TripCardView()
                
            }
            .background(Color(.systemGray6))
            .navigationTitle("Fleet Control")
        }
    }
}

// MARK: - Components

struct ActionButton: View {
    var icon: String
    var title: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            Text(title)
                .font(.footnote)
                .foregroundColor(.white)
        }
        .frame(width: 120, height: 100)
        .background(color)
        .cornerRadius(12)
    }
}

struct ActivityCard: View {
    var icon: String
    var title: String
    var subtitle: String
    var time: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
    }
}


struct InfoCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .bold()
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
struct TripCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with "See all" link
            HStack {
                Image(systemName:"car")
//                    .foregroundColor(.green)
                Text("VH-2024")
                    .font(.headline)
                    .bold()
                
                Spacer()
//                
//                Text("See all")
//                    .font(.caption)
//                    .foregroundColor(.blue)
            }
            
            // Departure and Destination
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.green)
                    Text("San Francisco, CA")
                }
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text("Los Angeles, CA")
                }
            }
            Rectangle().frame(width: .infinity, height:1)
            
            // Departure and ETA
            HStack(spacing: 16) {
                Label {
                    Text("Departure: Feb 15, 2024")
                } icon: {
                    Image(systemName: "calendar")
                }
                
                Spacer()
                
                Label {
                    Text("ETA: Feb 16, 2024")
                } icon: {
                    Image(systemName: "clock")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}
//
//struct TripCardView: View {
//    let trip = Trip(
//        id: "VH-2024",
//        departure: "San Francisco, CA",
//        destination: "Los Angeles, CA",
//        departureDate: "Feb 15, 2024",
//        eta: "Feb 16, 2024"
//    )
//    
//    let columns = [
//        GridItem(.flexible(), spacing: 10),
//        GridItem(.flexible(), spacing: 10)
//    ]
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text(trip.id)
//                    .font(.headline)
//                    .bold()
//                
//                Spacer()
//                
//                Image(systemName: "person.crop.circle") // Profile Icon
//            }
//            .padding(.bottom, 5)
//            
//            LazyVGrid(columns: columns, spacing: 10) {
//                VStack{
//                    VStack {
//                        HStack{
//                            Image(systemName: "mappin.circle.fill")
//                                .foregroundColor(.green)
//                            Text(trip.departure)
//                        }
//                        HStack{
//                            
//                            Image(systemName: "mappin.circle.fill")
//                                .foregroundColor(.red)
//                            Text(trip.destination)
//                        }
//                    }
//                    VStack{
//                        
//                        HStack {
//                            Image(systemName: "calendar")
//                            Text("Departure: \(trip.departureDate)")
//                        }
////                        Spacer()
////                        
//                        HStack {
//                            Image(systemName: "clock")
//                            Text("ETA: \(trip.eta)")
//                        }
//                    }
//                }
//            }
//            .padding(.top, 5)
//            
//            
//           
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
////        .shadow(radius: 3)
//        .frame(width: 360)
//        
//        
//    }
//}

// MARK: - Models

struct Trips {
    let id: String
    let departure: String
    let destination: String
    let departureDate: String
    let eta: String
}

// MARK: - Placeholder Views



// MARK: - Previews

#Preview {
    FleetControlDashboard()
}
