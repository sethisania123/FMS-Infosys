//
//  FleetManagerDashboard.swift
//  FMS
//
//  Created by Ankush Sharma on 11/02/25.
//
import SwiftUI


func generateExampleTrips() -> [Trip] {
    let driver1 = Driver(name: "John Doe", email: "john@example.com", phone: "123-456-7890", experience: .moreThanFive, license: "D12345", geoPreference: .plain, vehiclePreference: .truck, status: true)

    let driver2 = Driver(name: "Alice Smith", email: "alice@example.com", phone: "987-654-3210", experience: .lessThanFive, license: "A67890", geoPreference: .hilly, vehiclePreference: .van, status: true)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"

    let trip1Date = dateFormatter.date(from: "2025/02/01")!
    let trip2Date = dateFormatter.date(from: "2025/02/05")!
    let trip3Date = dateFormatter.date(from: "2025/02/10")!

    let trip1 = Trip(tripDate: trip1Date, startLocation: "New York", endLocation: "Los Angeles", distance: 2800.0, estimatedTime: 45.0, assignedDriver: driver1, TripStatus: .scheduled)

    let trip2 = Trip(tripDate: trip2Date, startLocation: "San Francisco", endLocation: "Chicago", distance: 2130.0, estimatedTime: 30.0, assignedDriver: driver2, TripStatus: .inprogress)

    let trip3 = Trip(tripDate: trip3Date, startLocation: "Boston", endLocation: "Miami", distance: 1500.0, estimatedTime: 18.0, assignedDriver: driver1, TripStatus: .completed)

    return [trip1, trip2, trip3]
}

// MARK: - Dashboard View
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
            
            TripdashBoard()
                .tabItem {
                    Label("Trips", systemImage: "map.fill")
                }
            
            FleetProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct DashboardView: View {
    var trips = generateExampleTrips()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        InfoCard(icon: "truck.box.fill", value: "48", title: "Total Vehicles", color: .blue)
                        InfoCard(icon: "map.fill", value: "23", title: "Active Trips", color: .green)
                        MainteneceInfoCard(icon: "person.3.fill", value: "32", title: "Maintenance Personnel", color: .purple)
                        InfoCard(icon: "person.crop.circle.fill", value: "45", title: "Total Drivers", color: .orange)
                    }
                    .padding(.horizontal)
                    
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
    
                   
//                    HStack {
                        Text("Recent Activities")
                            .font(.headline)
                            .padding(.horizontal)
////                        Spacer()
//                        Text("See all")
//                            .padding(.leading,150)
//                            .font(.system(size: 15))
//                            .foregroundColor(.blue)
//                    }
       
                    ForEach(trips, id: \.id) { trip in
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
                UINavigationBar.appearance().isTranslucent = false
            }
        }
        
    }
}

// MARK: - Trip Card View
struct TripCardView: View {
    var trip: Trip

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
                Text(trip.assignedDriver?.vehiclePreference.rawValue ?? "Unknown Vehicle")
                    .font(.headline)
                    .bold()
                
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                Text(trip.assignedDriver?.name ?? "No Driver")
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
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [10]))
                            .foregroundColor(.gray)
                    )
                    .padding(.leading, 30)

                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text(trip.endLocation)
                }
            }

            Rectangle()
                .frame(maxWidth: .infinity,maxHeight: 1)
                .foregroundColor(.gray)
                .opacity(0.5)

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

// MARK: - Preview
#Preview {
    FleetControlDashboard()
}
