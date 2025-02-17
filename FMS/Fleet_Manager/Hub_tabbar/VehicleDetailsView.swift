import SwiftUI
import FirebaseFirestore

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmationDialog = false
    @State private var showError = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var isEditing = false
    @State private var firestoreId: String?
    @State private var model: String
    @State private var vehicleType: VehicleType
    @State private var fuelType: FuelType
    @State private var mileage: String
    
    let db = Firestore.firestore()
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        _model = State(initialValue: vehicle.model)
        _vehicleType = State(initialValue: vehicle.type)
        _fuelType = State(initialValue: vehicle.fuelType)
        _mileage = State(initialValue: "\(vehicle.mileage)")
    }
    
    func findAndDeleteVehicle() {
        db.collection("vehicles")
            .whereField("registrationNumber", isEqualTo: vehicle.registrationNumber)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("❌ Error querying Firestore: \(error.localizedDescription)")
                    showError(message: "Error finding vehicle: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("❌ No matching vehicle found in Firestore")
                    showError(message: "Vehicle not found in database")
                    return
                }
                
                let firestoreDoc = documents[0]
                
                firestoreDoc.reference.delete { error in
                    if let error = error {
                        print("❌ Delete failed: \(error.localizedDescription)")
                        showError(message: "Failed to delete vehicle: \(error.localizedDescription)")
                    } else {
                        print("✅ Vehicle successfully deleted")
                        DispatchQueue.main.async {
                            showSuccess = true
                        }
                    }
                }
            }
    }
    
    func updateVehicleDetails() {
        print("🔄 Attempting to update vehicle details...")
        
        // Validate mileage first
        guard let updatedMileage = Int(mileage.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            showError(message: "Please enter a valid mileage number")
            return
        }
        
        db.collection("vehicles")
            .whereField("registrationNumber", isEqualTo: vehicle.registrationNumber)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("❌ Error querying Firestore: \(error.localizedDescription)")
                    showError(message: "Error finding vehicle: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents, let firestoreDoc = documents.first else {
                    print("❌ No matching vehicle found in Firestore")
                    showError(message: "Vehicle not found in database")
                    return
                }
                
                print("✅ Vehicle found in Firestore. Proceeding with update...")
                print("🔹 Current mileage value: \(mileage)")
                print("🔹 Converted mileage value: \(updatedMileage)")
                
                let updatedData: [String: Any] = [
                    "model": model,
                    "type": vehicleType.rawValue,
                    "fuelType": fuelType.rawValue,
                    "mileage": updatedMileage
                ]
                
                print("🔹 Updating with data: \(updatedData)")
                
                firestoreDoc.reference.updateData(updatedData) { error in
                    if let error = error {
                        print("❌ Update failed: \(error.localizedDescription)")
                        showError(message: "Failed to update vehicle: \(error.localizedDescription)")
                    } else {
                        print("✅ Vehicle successfully updated in Firestore")
                        DispatchQueue.main.async {
                            isEditing = false
                            showSuccess = true
                        }
                    }
                }
            }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Vehicle Image
                Image("Freightliner_M2_106_6x4_2014_(14240376744)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                
                // Vehicle Details Section
                Group {
                    DetailField(title: "Vehicle Type", value: vehicleType.rawValue, isEditable: isEditing, onChange: { newValue in
                        vehicleType = VehicleType(rawValue: newValue) ?? vehicleType
                    })
                    DetailField(title: "Model", value: model, isEditable: isEditing, onChange: { model = $0 })
                    DetailField(title: "Registration Number", value: vehicle.registrationNumber, isEditable: false)
                    DetailField(title: "Fuel Type", value: fuelType.rawValue, isEditable: isEditing, onChange: { newValue in
                        fuelType = FuelType(rawValue: newValue) ?? fuelType
                    })
                    DetailField(title: "Mileage", value: mileage, isEditable: isEditing, onChange: { mileage = $0 })
                }
                .padding(.horizontal)
                
                // Buttons
                VStack {
                    Spacer()
                    
                    if isEditing {
                        Button(action: updateVehicleDetails) {
                            Text("Save Changes")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    } else {
                        Button(action: {
                            showConfirmationDialog = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Vehicle")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationBarTitle(vehicle.model, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Cancel" : "Edit")
                }
            }
        }
        .background(Color(.systemGray6))
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage)
        }
        .alert("Success", isPresented: $showSuccess) {
            Button("OK") {
                showSuccess = false
                dismiss()
            }
        } message: {
            Text(isEditing ? "Vehicle updated successfully" : "Vehicle deleted successfully")
        }
        .confirmationDialog(
            "Delete Vehicle",
            isPresented: $showConfirmationDialog,
            actions: {
                Button("Delete", role: .destructive) {
                    findAndDeleteVehicle()
                }
                Button("Cancel", role: .cancel) {}
            },
            message: {
                Text("Are you sure you want to delete this vehicle? This action cannot be undone.")
            }
        )
    }
}

// Updated DetailField component
struct DetailField: View {
    let title: String
    let isEditable: Bool
    var onChange: ((String) -> Void)?
    
    @State private var localText: String
    
    init(title: String, value: String, isEditable: Bool, onChange: ((String) -> Void)? = nil) {
        self.title = title
        self.isEditable = isEditable
        self.onChange = onChange
        _localText = State(initialValue: value)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            if isEditable {
                TextField("", text: $localText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onChange(of: localText) { newValue in
                        onChange?(newValue)
                    }
                    .keyboardType(title == "Mileage" ? .numberPad : .default)
            } else {
                TextField("", text: .constant(localText))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
}

// Document View Component
struct DocumentView: View {
    let title: String
    let imageName: UIImage
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            Image(uiImage: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .cornerRadius(10)
                .shadow(radius: 8)
                .padding(.horizontal)
        }
    }
}

#Preview {
    VehicleDetailsView(vehicle: Vehicle(type: .truck, model: "Toyota RAV4", registrationNumber: "KA01 AB234", fuelType: .petrol, mileage: 15000, rc: "rcImage", vehicleImage: "vehicleImage", insurance: "insuranceImage", pollution: "pollutionImage", status: true))
}
