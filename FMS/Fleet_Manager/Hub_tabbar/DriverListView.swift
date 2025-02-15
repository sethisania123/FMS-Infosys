
#Preview {
    DriverListView()
}
import SwiftUI
import FirebaseFirestore

struct DriverListView: View {
    @State private var searchText = ""
    @State private var users: [User] = []
    private let db = Firestore.firestore()

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .padding(.top,20)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                List(filteredUsers, id: \.id) { user in
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(.bottom, 45)

                        VStack(alignment: .leading, spacing: 5) {
                            VStack {
                                Text(user.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.leading, -33)
                                Text(user.phone)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 5)

                            Text("Experience: \(user.name)")
                                .font(.footnote)
                                .foregroundColor(.black)
                                .padding(.leading, -35)
                            Text("Terrain specialization: \(user.name)")
                                .font(.footnote)
                                .foregroundColor(.black)
                                .padding(.leading, -35)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
                .frame(width:400)
//                .scrollContentBackground(.hidden)
//                .background(Color.black)
//                .background(Color.gray)
            }
//            .background(Color.black)
            
            .onAppear(perform: fetchUsersDriver)
//            .navigationTitle("Drivers")
//            .foregroundColor(.white)
           
        }.background(Color(.systemGray6))
       
    }

    func fetchUsersDriver() {
        db.collection("users").whereField("role", isEqualTo: "Driver").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.users = documents.compactMap { doc in
                let user = try? doc.data(as: User.self)
                return user?.id != nil ? user : nil
            }
        }
    }
}
















//import SwiftUI
//import FirebaseFirestore
//
//
//struct DriverListView: View {
//    @State private var users: [User] = []
//    private let db = Firestore.firestore()
//    
//    var body: some View {
//<<<<<<< HEAD
//        NavigationStack {
//            VStack {
//                // Search Bar
//                TextField("Search", text: $searchText)
//                    .padding(10)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//
//                // Driver2 List
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(filteredDrivers) { Driver2 in
//                            HStack {
//                                Image(systemName: "person.crop.circle.fill")
//                                    .foregroundColor(.black)
//                                    .font(.title2)
//                                    .padding(.bottom,50)
//                                VStack(alignment: .leading, spacing: 5) {
//                                    VStack{
//                                        Text(Driver2.name)
//                                            .font(.headline)
//                                            .bold()
//                                        Text(Driver2.phoneNumber)
//                                            .font(.subheadline)
//                                            .foregroundColor(.black)
//                                    }.padding(3)
//                                    Text("Experience: \(Driver2.experience)")
//                                        .font(.footnote)
//                                        .foregroundColor(.black)
//                                        .padding(.leading,-30)
//                                    Text("Terrain specialisation: \(Driver2.specialization)")
//                                        .font(.footnote)
//                                        .foregroundColor(.black)
//                                        .padding(.leading,-30)
//                                }
//                                Spacer()
//                                
//                                // Status Label
//                                Text(Driver2.status)
//                                    .font(.caption)
//                                    .bold()
//                                    .foregroundColor(.green)
//                                    .padding(5)
//                                    .background(Color.green.opacity(0.2))
//                                    .cornerRadius(10)
//                                    .padding(.bottom,70)
//                                
//                                // Delete Button
////                                Button(action: {
////                                    // Handle delete action
////                                }) {
////                                    Image(systemName: "trash")
////                                        .foregroundColor(.red)
////                                }
//                            }
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
//                        }
//                    }
//                    .padding()
//                }
//            }
////            .navigationTitle("Drivers")
////            .navigationBarTitleDisplayMode(.inline)
////            .navigationBarItems(leading: Button("Back") {}, trailing: EmptyView())
////            .toolbar {
////                ToolbarItemGroup(placement: .bottomBar) {
////                    Spacer()
////                    Image(systemName: "house")
////                    Spacer()
////                    Image(systemName: "square.stack.3d.up")
////                    Spacer()
////                    Image(systemName: "star")
////                    Spacer()
////                    Image(systemName: "ellipsis")
////                    Spacer()
////                }
////            }
//=======
//        List(users, id: \.id ) { user in
//            VStack(alignment: .leading) {
//                Text(user.name)
//                    .font(.headline)
//                Text("Email: \(user.email)")
//                    .font(.subheadline)
//                Text("Phone: \(user.phone)")
//                    .font(.subheadline)
//                Text("Role: \(user.role.rawValue)")
//                    .font(.subheadline)
//            }
//            .padding()
//        }
//        .onAppear(perform: fetchUsersDriver)
//        .navigationTitle("Drivers")
//    }
//    
//    private func fetchUsersDriver() {
//        db.collection("users").whereField("role", isEqualTo: "Driver").getDocuments { snapshot, error in
//            guard let documents = snapshot?.documents, error == nil else {
//                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            self.users = documents.compactMap { doc in
//                let user = try? doc.data(as: User.self)
//                return (user?.id != nil) ? user : nil
//            }
//>>>>>>> 22b0ab771dbd95e8880da6b79f8cd1ff19f07b53
//        }
//    }
//    
//
//}
//

//import SwiftUI
//
//import FirebaseFirestore
//
//struct DriverListView: View {
//    @State private var searchText = ""
//    
//    
////    @State private var drivers = [
////        Driver(name: "John Anderson", email: "john@example.com", phone: "+91 7635467832", experience: .moreThanFive, license: "ABC123", geoPreference: .hilly, vehiclePreference: .truck, status: true),
////        Driver(name: "Alice Brown", email: "alice@example.com", phone: "+91 9876543210", experience: .lessThanFive, license: "XYZ789", geoPreference: .plain, vehiclePreference: .van, status: false)
////    ]
////
////    var filteredDrivers: [Driver] {
////        if searchText.isEmpty {
////            return drivers
////        } else {
////            return drivers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
////        }
////    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextField("Search", text: $searchText)
//                    .padding(10)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(filteredDrivers) { driver in
//                            DriverRow(driver: driver)
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//    }
//}

//struct DriverRow: View {
//    let driver: Driver
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "person.crop.circle.fill")
//                .foregroundColor(.black)
//                .font(.title2)
//                .padding(.bottom, 50)
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text(driver.name)
//                    .font(.headline)
//                    .bold()
//                Text(driver.phone)
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                Text("Experience: \(driver.experience.rawValue)")
//                    .font(.footnote)
//                    .foregroundColor(.black)
//                Text("Terrain specialization: \(driver.geoPreference.rawValue)")
//                    .font(.footnote)
//                    .foregroundColor(.black)
//            }
//            Spacer()
//            
//            Text(driver.status ? "Available" : "Unavailable")
//                .font(.caption)
//                .bold()
//                .foregroundColor(driver.status ? .green : .red)
//                .padding(5)
//                .background(driver.status ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
//                .cornerRadius(10)
//                .padding(.bottom, 70)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//    }
//}
