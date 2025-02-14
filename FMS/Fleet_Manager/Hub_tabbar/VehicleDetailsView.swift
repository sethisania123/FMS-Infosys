//
//  hubtabbar.swift
//  FMS
//
//  Created by Ankush Sharma on 13/02/25.
//
import SwiftUI

struct VehicleDetailsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Vehicle Image
                Image("vehicle_image") // Replace with actual image asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Vehicle Details
                Group {
                    DetailField(title: "Vehicle Type", value: "SUV")
                    DetailField(title: "Model", value: "Toyota RAV4 2023")
                    DetailField(title: "Registration Number", value: "KA01 AB234")
                    DetailField(title: "Fuel Type", value: "Petrol")
                    DetailField(title: "Mileage", value: "15,000 km")
                }
                .padding(.horizontal)

                // Documents
                Group {
                    DocumentView(title: "RC", imageName: "rc_image") // Replace with actual asset name
                    DocumentView(title: "Insurance", imageName: "insurance_image")
                    DocumentView(title: "Pollution Certificate", imageName: "pollution_certificate_image")
                }
            }
            .padding(.top)
        }
//        .navigationTitle("Vehicle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button("Back") {
//                    // Handle back action
//                }
//            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    // Handle edit action
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

// Component for displaying text fields
struct DetailField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: .constant(value))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
        }
    }
}

// Component for displaying document images
struct DocumentView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        VehicleDetailsView()
    }
}
