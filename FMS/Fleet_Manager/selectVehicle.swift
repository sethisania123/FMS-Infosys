//
//  selectVehicle.swift
//  FMS
//
//  Created by Sania on 14/02/25.
//

import SwiftUI

struct FleetManagerView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    Button(action: {
                        // Action for Back button
                    }) {
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Fleet manager")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Action for Search button
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // Divider Line
                Divider()
                    .background(Color.gray.opacity(0.3))

                // List of Vehicles
                ScrollView {
                    VStack(spacing: 16) {
                        VehicleRow(identifier: "DEF 456", type: "Truck", status: "Available")
                        VehicleRow(identifier: "ABC 123", type: "Sedan", status: "Available")
                        VehicleRow(identifier: "XYZ 789", type: "Van", status: "Available")
                        VehicleRow(identifier: "DEF 456", type: "Truck", status: "Available")
                        VehicleRow(identifier: "ABC 123", type: "Sedan", status: "Available")
                        VehicleRow(identifier: "ABC 123", type: "Sedan", status: "Available")
                    }
                    .padding()
                }

                // Bottom Tab Bar
                HStack {
                    TabButton(icon: "house", label: "Home")
                    Spacer()
                    TabButton(icon: "map", label: "Trips")
                    Spacer()
                    TabButton(icon: "location", label: "Navigation")
                    Spacer()
                    TabButton(icon: "person", label: "Profile")
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .navigationBarHidden(true)
        }
    }
}

// Custom View for Vehicle Row
struct VehicleRow: View {
    var identifier: String
    var type: String
    var status: String

    var body: some View {
        HStack {
            // Vehicle Details (Left Side)
            VStack(alignment: .leading, spacing: 4) {
                Text(identifier)
                    .font(.headline)
                Text(type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer() // Pushes the "Available" button to the right

            // Available Button (Right Side)
            Text(status)
                .font(.subheadline)
                .foregroundColor(.green)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// Custom View for Tab Button
struct TabButton: View {
    var icon: String
    var label: String

    var body: some View {
        Button(action: {
            // Action for button
        }) {
            VStack {
                Image(systemName: icon)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(.blue)
        }
    }
}

struct FleetManagerView_Previews: PreviewProvider {
    static var previews: some View {
        FleetManagerView()
    }
}
