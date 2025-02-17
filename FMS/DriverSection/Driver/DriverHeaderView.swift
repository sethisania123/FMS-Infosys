//
//  DriverHeaderView.swift
//  FMS
//
//  Created by Prince on 14/02/25.
//
import SwiftUI

struct DriverHeaderView: View {
    @State private var isAvailable: Bool = true

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                // Profile Image using SF Symbol
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Fleet Fly")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text("Professional Driver")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Availability Toggle with Label
                HStack(spacing: 5) {
                    Text("Available")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Toggle("", isOn: $isAvailable)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
            }
            .padding()
            .background(Color.white) // White background
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // Soft shadow effect
            .padding(.horizontal)
        }
    }
}

// Parent View with Reserved Space for Navigation
struct DriverScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer() // Reserve space for navigation (adjust later dynamically)
                .frame(height: 44) // Standard navigation bar height
            
            DriverHeaderView()
            
            Spacer()
        }
        .background(Color(.systemGray6)) // Light gray background
        .edgesIgnoringSafeArea(.bottom) // Prevents cutting at bottom
    }
}

#Preview {
    DriverScreen()
}
