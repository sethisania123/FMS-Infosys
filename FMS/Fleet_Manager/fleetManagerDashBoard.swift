//
//  FleetManagerDashboard.swift
//  FMS
//
//  Created by Ankush Sharma on 11/02/25.
//

import SwiftUI

//Example not officail //
///--------------------------------
class Trippp {
    var tripDate: Date
    var VehicleName: String
    var startLocation: String
    var endLocation: String
    var estimatedTime: Float
    var assignedDriver: Driverrr?  // Driver is optional; it may or may not be assigned

    // Updated initializer with driver information
    init(tripDate: Date, startLocation: String, endLocation: String, estimatedTime: Float, assignedDriver: Driverrr? = nil, VehicleName: String) {
        self.tripDate = tripDate
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.estimatedTime = estimatedTime
        self.assignedDriver = assignedDriver
        self.VehicleName = VehicleName
    }
}
///--------------------------------///--------------------------------

// Driver class
class Driverrr {
    var name: String
    var vehicle: String

    init(name: String, vehicle: String) {
        self.name = name
        self.vehicle = vehicle
    }
}

// Example trips for testing
func generateExampleTrips() -> [Trippp] {
    let driver1 = Driverrr(name: "John Doe", vehicle: "Toyota Prius")
    let driver2 = Driverrr(name: "Jane Smith", vehicle: "Ford Mustang")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    let trip1Date = dateFormatter.date(from: "2025/02/01")!
    let trip2Date = dateFormatter.date(from: "2025/02/05")!
    let trip3Date = dateFormatter.date(from: "2025/02/10")!
    
    let trip1 = Trippp(tripDate: trip1Date, startLocation: "New York", endLocation: "Los Angeles", estimatedTime: 45.0, assignedDriver: driver1, VehicleName: "VH-2023")
    let trip2 = Trippp(tripDate: trip2Date, startLocation: "San Francisco", endLocation: "Chicago", estimatedTime: 30.0, assignedDriver: driver2, VehicleName: "SD_5655")
    let trip3 = Trippp(tripDate: trip3Date, startLocation: "Boston", endLocation: "Miami", estimatedTime: 18.0, assignedDriver: driver1, VehicleName: "HU-9088")
    
    return [trip1, trip2, trip3]
}

///----------------------------------------------------------

struct FleetControlDashboard: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            hubTabBar()
                .tabItem {
                    Label("Hub", systemImage: "square.stack.3d.up")
                }
            
            Text("Map View")
                .tabItem {
                    Label("Trips", systemImage: "map.fill")
                }
            
            FleetProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
//        .navigationTitle("Fleet Control")
    }
}

struct DashboardView: View {
    var trips = generateExampleTrips()  // Getting the list of trips

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Grid of Info Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        InfoCard(icon: "truck.box.fill", value: "48", title: "Total Vehicles", color: .blue)
                        InfoCard(icon: "map.fill", value: "23", title: "Active Trips", color: .green)
                        MainteneceInfoCard(icon: "person.3.fill", value: "32", title: "Maintenance Personnel", color: .purple)
                        InfoCard(icon: "person.crop.circle.fill", value: "45", title: "Total Drivers", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions Section
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        NavigationLink(destination: AddNewTripView()) {
                            ActionButton(icon: "map", title: "Create Trip", color: .blue)
                        }
                        NavigationLink(destination: AddNewVehicle()) {
                            ActionButton(icon: "truck.box.fill", title: "Add Vehicle", color: .blue)
                        }
                        
                        NavigationLink(destination: AddUserForm()) {
                            ActionButton(icon: "person.badge.plus", title: "Add User", color: .purple)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Activities Section
                    HStack {
                        Text("Recent Activities")
                            .font(.headline)
                            .padding(.horizontal)
                        Spacer().frame(minWidth: 100, maxWidth: 170)
                       
                            Text("See all")
                                .font(.system(size: 15))
                                .foregroundColor(.blue)
                        
                    }
                    
                    // Rendering Trip Cards dynamically
                    ForEach(trips, id: \.VehicleName) { trip in
                        TripCardView(trip: trip)
                            .padding(.bottom)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Fleet Control")
            .onAppear {
                UINavigationBar.appearance().backgroundColor = .white
//                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().isTranslucent = false
            }

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
struct InfoCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Circle behind the image
                VStack{
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40) // Adjust size of the circle
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(.white) // Icon color inside the circle
                    }.padding(.leading,-80)
                    
                    // Title and value aligned to the left
                    VStack(alignment: .leading, spacing: 4) {
                        Text(value)
                            .font(.title)
                            .bold()
                        
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }.padding(.leading,-80)
                    
                    Spacer() // Keeps the content to the left
                }
            }
            .padding(.top, 16)
            .padding(.leading, 14) // This ensures the left padding for all the content
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
struct MainteneceInfoCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Circle behind the image
                VStack{
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40) // Adjust size of the circle
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(.white) // Icon color inside the circle
                    }.padding(.leading,-80)
                    
                    // Title and value aligned to the left
                    VStack(alignment: .leading, spacing: 4) {
                        Text(value)
                            .font(.title)
                            .bold()
                        
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer() // Keeps the content to the left
                }
            }
            .padding(.top, 16)
            .padding(.leading, 14) // This ensures the left padding for all the content
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}



struct TripCardView: View {
    var trip: Trippp

    // Function to format the date
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "car")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                Text(trip.VehicleName)
                    .font(.headline)
                    .bold()
                
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                Text(trip.assignedDriver?.name ?? "")
                    .font(.headline)
                    .bold()
                   
                
            }
            
            // Departure and Destination
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.green)
                    Text(trip.startLocation)
                }
                Rectangle()
                      .frame(width: 1)
                      .foregroundColor(.gray)
                      .opacity(0.5)
                      .overlay(
                          Rectangle()
                              .stroke(style: StrokeStyle(lineWidth: 1, dash: [10])) // Customize the dash length
                              .foregroundColor(.gray)
                      )
                      .padding(.leading,30)
                
                
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text(trip.endLocation)
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.gray)
                .opacity(0.5)
//=======
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
            HStack(spacing: 16) {
                Label {
                    Text("Departure: \(formatDate(trip.tripDate))")
                } icon: {
                    Image(systemName: "calendar")
                }
                
                Spacer()
                
                // Calculating ETA based on trip's estimated time
                let etaDate = trip.tripDate.addingTimeInterval(TimeInterval(trip.estimatedTime * 3600)) // ETA in hours
                Label {
                    Text("ETA: \(formatDate(etaDate))")
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

// MARK: - Previews

#Preview {
    FleetControlDashboard()
}
