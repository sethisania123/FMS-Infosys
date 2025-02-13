//
//  CurrentDestinationView.swift
//  FMS
//
//  Created by Prince on 11/02/25.
//

import SwiftUI

struct CurrentDestinationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Title and On-Time Status
            HStack {
                Text("Current Destination")
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                Text("On Time")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(12)
            }
            
            Text("Los Angeles Port Terminal")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 6) {
                Text("Progress")
                    .font(.caption)
                
                ProgressView(value: 0.68)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 5)
                    .tint(.blue)
            }
            
            // ETA and Distance Row
            HStack {
                VStack(alignment: .leading) {
                    Text("ETA")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("14:30")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("580Km left")
                        .font(.headline)
                        .bold()
                }
            }
            
            // **Action Buttons**
            HStack(spacing: 20) {
                Spacer()
                
                ActionButton2(title: "Start Trip", icon: "play.fill", bgColor: Color.green.opacity(0.2), iconColor: .green)
                
                Spacer()
                
                ActionButton2(title: "End Trip", icon: "stop.fill", bgColor: Color.red.opacity(0.2), iconColor: .red)
                
                Spacer()
                
                ActionButton2(title: "SOS", icon: "exclamationmark.triangle.fill", bgColor: Color.orange.opacity(0.2), iconColor: .orange)
                
                Spacer()
            }
            .padding(.top, 8)
            
          

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Action Button Component
struct ActionButton2: View {
    let title: String
    let icon: String
    let bgColor: Color
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(bgColor)
                .frame(width: 65, height: 65)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                )
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview
struct CurrentDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDestinationView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
