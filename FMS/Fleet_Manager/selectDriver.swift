//
//  selectDriver.swift
//  FMS
//
//  Created by Sania on 14/02/25.
//


import SwiftUI

struct DriverSelectionView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Top Navigation Bar
                HStack {
                    Button(action: {
                        // Action for Back button
                    }) {
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Select Driver")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Action for Done button
                    }) {
                        Text("Done")
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // Search Bar
                TextField("Search", text: .constant(""))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Driver Information
                VStack(alignment: .leading, spacing: 9) {
                    Text("John Anderson")
                        .font(.title2)
                    Text("+91 7635467832")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Available")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("Experience : 5 years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Terrain specialisation : Hilly area")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                
                
                VStack(alignment: .leading, spacing: 9) {
                    Text("John Anderson")
                        .font(.title2)
                    Text("+91 7635467832")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Available")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("Experience : 5 years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Terrain specialisation : Hilly area")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 9) {
                    Text("John Anderson")
                        .font(.title2)
                    Text("+91 7635467832")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Available")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("Experience : 5 years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Terrain specialisation : Hilly area")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct DriverSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DriverSelectionView()
    }
}
