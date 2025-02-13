//
//   ProfileView.swift
//  FMS
//
//  Created by Prince on 13/02/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var isEditing = false
    @State private var name = "John Anderson"
    @State private var email = "john.anderson@company.com" // Read-only
    @State private var phone = "+1 (555) 123-4567"
    @State private var experience = "5 Years"
    @State private var vehicleType = "Heavy Truck"
    @State private var specializedTerrain = "Mountain, Highway"
    @State private var licenseImage: UIImage? = nil // Placeholder for license image

    var body: some View {
        VStack(spacing: 20) {
            // Centered Name at the Top
            Text(name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 20)

            // Edit Button
            Button(action: { isEditing.toggle() }) {
                HStack {
                    Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                    Text(isEditing ? "Save Changes" : "Edit Profile")
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.blue)
            }

            // Editable Fields (Name, Phone) + Read-Only Email
            SectionCard {
                ProfileRow(icon: "person.fill", title: "Name", value: $name, isEditable: isEditing)
                ProfileRow(icon: "envelope.fill", title: "Email", value: .constant(email), isEditable: false) // Read-only
                ProfileRow(icon: "phone.fill", title: "Phone", value: $phone, isEditable: isEditing)
            }

            // License Image Section
            SectionCard {
                VStack {
                    Text("License Image")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let image = licenseImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 150)
                            .cornerRadius(8)
                            .overlay(
                                Text("No Image Available")
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .padding(.horizontal)
            }

            // Experience & Expertise
            SectionCard {
                ProfileRow(icon: "clock.fill", title: "Experience", value: .constant(experience), isEditable: false)
                ProfileRow(icon: "car.fill", title: "Vehicle Type", value: .constant(vehicleType), isEditable: false)
                ProfileRow(icon: "map.fill", title: "Specialized Terrain", value: .constant(specializedTerrain), isEditable: false)
            }

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1)) // Light gray background for better contrast
        .navigationBarHidden(true) // Hide default navigation bar
    }
}

// Reusable Profile Row Component with SF Symbols
struct ProfileRow: View {
    var icon: String
    var title: String
    @Binding var value: String
    var isEditable: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(title)
                .bold()
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.black)

            if isEditable {
                TextField("Enter \(title)", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(value)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

// Reusable Card Layout for Sections
struct SectionCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 16) {
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
