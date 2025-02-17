//
//  RecentActivitiesView.swift
//  FMS
//
//  Created by Prince on 14/02/25.
//

import SwiftUI

struct RecentActivitiesView: View {
    let activities = [
        ("456 Market St", "10:30 AM"),
        ("789 Tech Park", "09:15 AM"),
        ("321 Harbor View", "08:00 AM")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activities")
                .font(.headline)
                .bold()
                .padding(.horizontal)

            // White Card for all Activities
            VStack(spacing: 8) {
                ForEach(activities, id: \.0) { activity in
                    HStack {
                        // Location Icon with Green Dot
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 20))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(activity.0)
                                .font(.body)
                                .bold()

                            Text(activity.1)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()

                        // Delivered Status
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))

                            Text("Delivered")
                                .foregroundColor(.green)
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    
                    // Divider Line Between Activities (except last one)
                    if activity.0 != activities.last?.0 {  // ✅ Fixed error here
                        Divider()
                    }
                }
            }
            .background(Color.white) // White card for all activities
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // Soft shadow effect
            .padding(.horizontal)
        }
        .padding(.top, 10)
        .background(Color(.systemGray6)) // Light gray background for the screen
    }
}

#Preview {
    RecentActivitiesView()
}
