//
//  ShowVehicleListView.swift
//  FMS
//
//  Created by Deepankar Garg on 17/02/25.
//

import SwiftUI
import FirebaseFirestore

struct ShowVehicleListView: View {
    // State variable to hold the list of vehicles
    @State private var vehicles: [Vehicle] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    // Fetch vehicles from Firestore when the view appears
    func fetchVehicles() {
        let db = Firestore.firestore()
        db.collection("vehicles").getDocuments { snapshot, error in
            if let error = error {
                // Handle error by updating errorMessage state
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching vehicles: \(error.localizedDescription)"
                    self.isLoading = false
                }
                print("Error fetching vehicles: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                // Handle case where snapshot is nil
                DispatchQueue.main.async {
                    self.errorMessage = "No vehicles found."
                    self.isLoading = false
                }
                return
            }
            
            let vehicles = snapshot.documents.compactMap { document -> Vehicle? in
                do {
                    let vehicleData = try document.data(as: Vehicle.self)
                    return vehicleData
                } catch {
                    print("Error decoding vehicle: \(error)")
                    return nil
                }
            }
            
            // Update state with the fetched vehicles
            DispatchQueue.main.async {
                self.vehicles = vehicles
                self.isLoading = false
            }
        }
    }

    // Load data when the view appears
    var body: some View {
        VStack {
            if isLoading {
                // Show a loading indicator while fetching
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = errorMessage {
                // Display an error message if fetching fails
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Display the list of vehicles once data is fetched
                List(vehicles) { vehicle in
                    VStack(alignment: .leading) {
                        Text(vehicle.model)
                            .font(.headline)
                        Text("Type: \(vehicle.type.rawValue)")
                            .font(.subheadline)
                        Text("Mileage: \(vehicle.mileage) km")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .onAppear {
            fetchVehicles()  // Fetch the vehicles when the view appears
        }
        .navigationTitle("Vehicle List")
    }
}

#Preview {
    ShowVehicleListView()
}
