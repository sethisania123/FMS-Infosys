//
//  DriverListView.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//
import SwiftUI

struct Driver2: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let experience: String
    let specialization: String
    let status: String
}

struct DriverListView: View {
    @State private var searchText = ""
    @State private var drivers = [
        Driver2(name: "John Anderson", phoneNumber: "+91 7635467832", experience: "5 years", specialization: "Hilly area", status: "Available"),
        Driver2(name: "John Anderson", phoneNumber: "+91 7635467832", experience: "5 years", specialization: "Hilly area", status: "Available"),
        Driver2(name: "John Anderson", phoneNumber: "+91 7635467832", experience: "5 years", specialization: "Hilly area", status: "Available")
    ]
    
    var filteredDrivers: [Driver2] {
        if searchText.isEmpty {
            return drivers
        } else {
            return drivers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Driver2 List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredDrivers) { Driver2 in
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(Driver2.name)
                                        .font(.headline)
                                        .bold()
                                    Text(Driver2.phoneNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Experience: \(Driver2.experience)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Text("Terrain specialisation: \(Driver2.specialization)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                // Status Label
                                Text(Driver2.status)
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.green)
                                    .padding(5)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(10)
                                
                                // Delete Button
//                                Button(action: {
//                                    // Handle delete action
//                                }) {
//                                    Image(systemName: "trash")
//                                        .foregroundColor(.red)
//                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Drivers")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(leading: Button("Back") {}, trailing: EmptyView())
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Image(systemName: "house")
                    Spacer()
                    Image(systemName: "square.stack.3d.up")
                    Spacer()
                    Image(systemName: "star")
                    Spacer()
                    Image(systemName: "ellipsis")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DriverListView()
}

