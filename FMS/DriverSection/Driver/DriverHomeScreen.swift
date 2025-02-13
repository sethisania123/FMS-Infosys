//
//  DriverHomeScreen.swift
//  FMS
//
//  Created by Prince on 11/02/25.
//

import SwiftUI

struct DriverHomeScreen: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sticky Header (Title)
                HStack {
                    Text("Home")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)
                .background(Color.white) // Sticky Effect
                .zIndex(1) // Keep it above ScrollView
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AssignedVehicleView()
                        CurrentDestinationView()
                        RecentActivityView()
                        
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true) // Hide default navigation bar
            .background(Color(.systemGray6)) // Light Gray Background
        }
    }
}

#Preview {
    DriverHomeScreen()
}
