//
//  HomeView.swift
//  FMS
//
//  Created by Prince on 14/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ✅ Navigation Title (Fixed)
                Text("Driver Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8) // Adjust spacing from top
                    .padding(.bottom, 8) // Adjust spacing before scroll

                // ✅ Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        DriverHeaderView() // ✅ Scroll starts from here
                        CurrentTripView()
                        RecentActivitiesView()
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGray6)) // Matches background
        }
    }
}

#Preview {
    HomeView()
}
