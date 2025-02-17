//
//  VehicleListview.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//
import SwiftUI

struct Vehicledummy: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let status: String
}

struct VehicleListView: View {
    @State private var searchText = ""
    @State private var selectedType: String = "All"
    @State private var selectedStatus: String = "All"
    @State private var sortOption: String = "All"
    
    @State private var vehicles = [
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active"),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive"),
        Vehicledummy(name: "XYZ 789", type: "Van", status: "Active"),
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active"),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive"),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive"),
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active"),
        Vehicledummy(name: "XYZ 789", type: "Van", status: "Active"),
    ]
    
    // Filtered and Sorted Vehicles
    var filteredVehicles: [Vehicledummy] {
        var filtered = vehicles
        
        if selectedType != "All" {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        if selectedStatus != "All" {
            filtered = filtered.filter { $0.status == selectedStatus }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch sortOption {
        case "Sort by Name":
            filtered.sort { $0.name < $1.name }
        case "Sort by Status":
            filtered.sort { $0.status < $1.status }
        default:
            break
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search vehicles...", text: $searchText)
                    .padding(10)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 35)
                
                // Filters
                VStack(alignment: .leading) {
                    Text("Filter")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                        .padding(.bottom, -8)
                    
                    HStack {
                        // Type Filter
                        Menu {
                            Button("All") { selectedType = "All" }
                            Button("Truck") { selectedType = "Truck" }
                            Button("Sedan") { selectedType = "Sedan" }
                            Button("Van") { selectedType = "Van" }
                        } label: {
                            filterMenuLabel(text: selectedType)
                        }
                        
                        // Status Filter
                        Menu {
                            Button("All") { selectedStatus = "All" }
                            Button("Active") { selectedStatus = "Active" }
                            Button("Inactive") { selectedStatus = "Inactive" }
                        } label: {
                            filterMenuLabel(text: selectedStatus)
                        }
                        
                        // Sorting Options
                        Menu {
                            Button("All") { sortOption = "All" }
                            Button("Sort by Name") { sortOption = "Sort by Name" }
                            Button("Sort by Status") { sortOption = "Sort by Status" }
                        } label: {
                            filterMenuLabel(text: sortOption)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Vehicle List
                List {
                   
                    ForEach(filteredVehicles) { vehicle in
                        NavigationLink(destination:VehicleDetailsView())
                        {
                            
                            HStack {
                                Image(systemName: "car.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text(vehicle.name)
                                        .font(.headline)
                                    Text(vehicle.type)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(vehicle.status)
                                    .foregroundColor(vehicle.status == "Active" ? .green : .red)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteVehicle)
                }
                .background(Color(.systemGray6))
            }.background(Color(.systemGray6))
            .padding(.top,20)
            
//            .navigationBarItems(trailing: Button(action: {}) {
//                Image(systemName: "plus")
//            }).background(Color(.systemGray6))
        }
        .navigationTitle("Vehicle")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteVehicle(at offsets: IndexSet) {
        vehicles.remove(atOffsets: offsets)
    }
    
    private func filterMenuLabel(text: String) -> some View {
        HStack {
            Text(text)
                .foregroundColor(.black)
            Image(systemName: "chevron.down")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    VehicleListView()
}
