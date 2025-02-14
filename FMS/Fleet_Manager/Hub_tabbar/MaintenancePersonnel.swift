//
//  MaintenancePersonnel.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//
import SwiftUI

struct MaintenancePerson: Identifiable {
    let id = UUID()
    let name: String
    let email: String
}

struct MaintenanceListView: View {
    @State private var searchText = ""
    @State private var maintenanceList = [
        MaintenancePerson(name: "Ram Prasad", email: "john.anderson@example.com"),
        MaintenancePerson(name: "Ram Prasad", email: "john.anderson@example.com"),
        MaintenancePerson(name: "Ram Prasad", email: "john.anderson@example.com")
    ]

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Maintenance List
                List {
                    ForEach(maintenanceList.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { person in
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.gray)
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text(person.name)
                                    .font(.headline)
                                Text(person.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
//                            Button(action: {
//                                // Handle delete action
//                            }) {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                            }
                        }
                        .padding(.vertical, 5)
//                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Maintenance")
//            .navigationBarItems(leading: Button("Back") {}, trailing: EmptyView())
        }
    }
}

#Preview {
    MaintenanceListView()
}
