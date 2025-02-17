import SwiftUI
import FirebaseFirestore

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmationDialog = false
    @State private var showError = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var firestoreId: String?
    
    let db = Firestore.firestore()
    
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
                
                // Get the Firestore document ID
                let firestoreDoc = documents[0]
                
                // Delete the document using the Firestore ID
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
                    DetailField(title: "Vehicle Type", value: vehicle.type.rawValue)
                    DetailField(title: "Model", value: vehicle.model)
                    DetailField(title: "Registration Number", value: vehicle.registrationNumber)
                    DetailField(title: "Fuel Type", value: vehicle.fuelType.rawValue)
                    DetailField(title: "Mileage", value: "\(vehicle.mileage) km")
                }
                .padding(.horizontal)

                // Delete Button
                VStack {
                    Spacer()
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
            .padding(.top)
        }
        .navigationBarTitle(vehicle.model, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // Handle edit action
                }) {
                    Text("Edit")
                }
            }
        }
        .background(Color(.systemGray6))
        // Error Alert
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
        // Success Alert
        .alert("Success", isPresented: $showSuccess) {
            Button("OK") {
                showSuccess = false
                dismiss()
            }
        } message: {
            Text("Vehicle deleted successfully")
        }
        // Confirmation Dialog
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

// Component for displaying text fields with improved styling
struct DetailField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: .constant(value))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

// Component for displaying document images with more attractive layout
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
