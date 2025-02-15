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
    var body: some View {
        NavigationStack {
            MaintenancePersonnelListview()
//                .navigationTitle("Maintenance")
                // Uncomment if you need a back button or other navigation items
                //.navigationBarItems(leading: Button("Back") { })
        }
    }
}

struct MaintenancePersonnelListview: View {
    @State private var searchText = ""
    @State private var maintenanceList = [
        MaintenancePerson(name: "Ram Prasad", email: "john.anderson@example.com"),
        MaintenancePerson(name: "Sham Prasad", email: "sham.anderson@example.com"),
        MaintenancePerson(name: "Raam Prasad", email: "raam.anderson@example.com")
    ]

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search", text: $searchText)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)

            // Maintenance List
            List {
                ForEach(maintenanceList.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) || $0.email.localizedCaseInsensitiveContains(searchText) }) { person in
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
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .onDelete(perform: deletePerson)
            }
            .listStyle(PlainListStyle())
        }
        .background(Color(.systemGray6))
    }

    private func deletePerson(at offsets: IndexSet) {
        // Make sure to delete the item from the actual data array
        maintenanceList.remove(atOffsets: offsets)
    }
}

#Preview {
    MaintenanceListView()
}
