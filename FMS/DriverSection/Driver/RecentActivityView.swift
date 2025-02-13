//
//  RecentActivityView.swift
//  FMS
//
//  Created by Prince on 13/02/25.
//

import SwiftUI

struct RecentActivityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .bold()
            
            VStack(spacing: 8) {
                ForEach(recentActivities) { activity in
                    RecentActivityRow(activity: activity)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Recent Activity Row
struct RecentActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            // ✅ Activity Icon
            Image(systemName: activity.icon)
                .font(.system(size: 24))
                .foregroundColor(activity.iconColor)
                .frame(width: 40, height: 40)
                .background(activity.bgColor.opacity(0.2))
                .cornerRadius(8)
            
            // ✅ Activity Details
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.subheadline)
                    .bold()
                
                Text(activity.date) // ✅ Changed to display date
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // ✅ Status
            Text(activity.status)
                .font(.footnote)
                .foregroundColor(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
    }
}

// MARK: - Activity Model
struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let date: String // ✅ Changed from `timestamp` to `date`
    let icon: String
    let iconColor: Color
    let bgColor: Color
    let status: String
    let statusColor: Color
}

// MARK: - Sample Data
let recentActivities: [Activity] = [
    Activity(title: "Trip Started", date: "Feb 10, 2025", icon: "play.fill", iconColor: .green, bgColor: .green, status: "Delivered", statusColor: .green),
    Activity(title: "Trip Paused", date: "Feb 09, 2025", icon: "pause.fill", iconColor: .orange, bgColor: .orange, status: "Delivered", statusColor: .green),
    Activity(title: "Trip Completed", date: "Feb 08, 2025", icon: "stop.fill", iconColor: .red, bgColor: .red, status: "Delivered", statusColor: .green)
]

// MARK: - Preview
struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        RecentActivityView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
