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
    let statusColor: Color
}

struct VehicleListView: View {
    @State private var searchText = ""
    @State private var vehicles = [
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active", statusColor: .green),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive", statusColor: .red),
        Vehicledummy(name: "XYZ 789", type: "Van", status: "Active", statusColor: .green),
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active", statusColor: .green),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive", statusColor: .red),
        Vehicledummy(name: "ABC 123", type: "Sedan", status: "Inactive", statusColor: .red),
        Vehicledummy(name: "DEF 456", type: "Truck", status: "Active", statusColor: .green),
        Vehicledummy(name: "XYZ 789", type: "Van", status: "Active", statusColor: .green),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search vehicles...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Filters
                HStack {
                    Menu("all") {
                        Button("Truck") {}
                        Button("Sedan") {}
                        Button("Van") {}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Menu("all") {
                        Button("Active") {}
                        Button("Inactive") {}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    Menu("all") {
                        Button("Sort by Name") {}
                        Button("Sort by Status") {}
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Vehicledummy List
                List {
                    ForEach(vehicles.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { Vehicledummy in
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text(Vehicledummy.name)
                                    .font(.headline)
                                Text(Vehicledummy.type)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(Vehicledummy.status)
                                .foregroundColor(Vehicledummy.statusColor)
//                            Button(action: {
//                                // Handle delete action
//                            }) {
//                                Image(systemName: "trash")
//                                    
////                                    .foregroundColor(.red)
//                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
//            .navigationTitle("Vehicles")
//            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "plus")
            })
        }
    }
}

#Preview {
    VehicleListView()
}

