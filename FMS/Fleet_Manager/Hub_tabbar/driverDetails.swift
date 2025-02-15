import SwiftUI
import _PhotosUI_SwiftUI
import FirebaseFirestore

struct DriverDetails: View {
    let user: User

    var body: some View {
        AddDriverView(user: user)
    }
}

struct AddDriverView: View {
    let user: User

    @State private var name: String
    @State private var email: String
    @State private var contactNumber: String
    @State private var licenseNumber: String = ""
    @State private var experience: String = ""
    @State private var selectedVehicle: String = "Truck"
    @State private var selectedTerrain: String = "Hilly"

    @State private var isEditing: Bool = false
    @State private var showAlert: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var licenseImage: UIImage? = nil

    private let db = Firestore.firestore()

    init(user: User) {
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _contactNumber = State(initialValue: user.phone)
    }

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Enter Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
            }

            Section(header: Text("Email")) {
                TextField("Enter Email", text: $email)
                    .disabled(!isEditing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Section(header: Text("Contact Number")) {
                TextField("Enter Contact Number", text: $contactNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
            }

            Section(header: Text("License Number")) {
                TextField("Enter License Number", text: $licenseNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
            }

            Section(header: Text("License Photo")) {
                ZStack {
                    if let image = licenseImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 150)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                    Text("Tap to upload")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                .onTapGesture {
                    showImagePicker.toggle()
                }
            }.disabled(!isEditing)

            Section(header: Text("Type of Vehicle")) {
                TextField("Enter Vehicle Type", text: $selectedVehicle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
            }

            Section(header: Text("Specialization in Terrain Type")) {
                TextField("Enter Terrain Type", text: $selectedTerrain)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
            }
        }
        .photosPicker(
            isPresented: $showImagePicker,
            selection: $selectedImageItem,
            matching: .images
        )
        .onChange(of: selectedImageItem) { newItem in
            Task {
                if let newItem = newItem, let data = try? await newItem.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        licenseImage = uiImage
                    }
                }
            }
        }
        .navigationBarTitle("Driver Details", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(isEditing ? "Done" : "Edit") {
                if isEditing {
                    showAlert = true
                } else {
                    isEditing = true
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Changes"),
                message: Text("Are you sure you want to save the changes?"),
                primaryButton: .default(Text("Yes"), action: {
                    updateDriverDetails()
                    isEditing = false
                }),
                secondaryButton: .cancel(Text("No"))
            )
        }
    }

    /// Updates driver details in Firestore
    private func updateDriverDetails() {
        guard let userId = user.id else { return }

        let driverData: [String: Any] = [
            "name": name,
            "email": email,
            "phone": contactNumber,
            "licenseNumber": licenseNumber,
            "selectedVehicle": selectedVehicle,
            "selectedTerrain": selectedTerrain
        ]

        db.collection("users").document(userId).updateData(driverData) { error in
            if let error = error {
                print("Error updating driver details: \(error.localizedDescription)")
            } else {
                print("Driver details updated successfully")
            }
        }
    }
}

#Preview {
    NavigationView {
        DriverDetails(user: User(
            name: "John Doe",
            email: "john.doe@example.com",
            phone: "1234567890",
            role: .driver
        ))
    }
}
