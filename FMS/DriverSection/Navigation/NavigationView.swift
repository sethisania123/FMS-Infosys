//
//  NavigationView.swift
//  FMS
//
//  Created by Prince on 11/02/25.
//

import SwiftUI
import MapKit

struct NavigationViewScreen: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        VStack {
            // Map View using the new API for iOS 17+
            Map(position: $cameraPosition)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapPitchToggle()
                }
                .frame(height: 300)
                .edgesIgnoringSafeArea(.top)

            // Delivery Details Card
            VStack(alignment: .leading, spacing: 10) {
                Text("Delivery Details")
                    .font(.headline)
                    .padding(.top, 10)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("Los Angeles Port Terminal")
                            .font(.headline)
                        Text("456 Enterprise Street, Tech District")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text("5.2 miles away")
                                .foregroundColor(.blue)
                            Text("• 15 mins")
                                .foregroundColor(.gray)
                        }
                        .font(.subheadline)
                    }
                }

                // Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        print("Start Navigation Pressed")
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Start Navigation")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        print("Mark as Delivered Pressed")
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Delivered")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()

            Spacer()
        }
        .navigationTitle("Current Trip")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview
struct NavigationViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationViewScreen()
        }
    }
}
