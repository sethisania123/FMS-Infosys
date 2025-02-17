//
//  ProfileView.swift
//  Fleet Manager Profile
//
//  Created by Kushgra Grover on 13/02/25.
//

import SwiftUI

struct fleetProfileView: View {
    var body: some View {
        NavigationView{
            VStack {
                // Profile Image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // Name
                Text("John Anderson")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                // Contact Info Card
                ContactInfoCard()
                    .padding()
                
                // Logout Button
                Button(action: {
                    print("Logout button tapped")
                }) {
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Edit button tapped")
            }) {
                Image(systemName: "pencil")
            })
        }
    }
}

struct ContactInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Information")
                .font(.headline)
                .fontWeight(.bold)

            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                Text("+1 (555) 123-4567")
            }

            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                Text("john.anderson@company.com")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
#Preview {
    fleetProfileView()
}
