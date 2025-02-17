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
    @State private var searchText = ""
    @State private var selectedVehicleType: VehicleType?

    // Computed property for filtered vehicles
        private var filteredVehicles: [Vehicle] {
            var filtered = vehicles
            
            // Apply search filter
            if !searchText.isEmpty {
                filtered = filtered.filter { vehicle in
                    vehicle.model.localizedCaseInsensitiveContains(searchText)
                }
            }
            
            // Apply type filter
            if let selectedType = selectedVehicleType {
                filtered = filtered.filter { vehicle in
                    vehicle.type == selectedType
                }
            }
            
            return filtered
        }
    
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

    private var filterPicker: some View {
            Menu {
                Button(action: { selectedVehicleType = nil }) {
                    HStack {
                        Text("All Types")
                        if selectedVehicleType == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                ForEach(VehicleType.allCases, id: \.self) { type in
                    Button(action: { selectedVehicleType = type }) {
                        HStack {
                            Text(type.rawValue)
                            if selectedVehicleType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.blue)
                    Text(selectedVehicleType?.rawValue ?? "Filter")
                        .foregroundColor(.blue)
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
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
                
                HStack {
                        SearchBar(text: $searchText)
                        filterPicker
                      }
                    .padding(.horizontal)
                
                // Display the list of vehicles once data is fetched
                List(filteredVehicles) { vehicle in
                    NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
                        VStack(alignment: .leading) {
                            Text(vehicle.model)
                                .foregroundColor(.black)
                                .font(.headline)
                            Text("Type: \(vehicle.type.rawValue)")
                                .font(.subheadline)
                            Text("Mileage: \(vehicle.mileage) km")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
            }
        }
        .onAppear {
            fetchVehicles()  // Fetch the vehicles when the view appears
        }
        .navigationTitle("Vehicle List")
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search vehicles...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}


#Preview {
    ShowVehicleListView()
}
