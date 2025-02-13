//
//  AssignedVehicleView.swift
//  FMS
//
//  Created by Prince on 11/02/25.
//

import SwiftUI

struct AssignedVehicleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Assigned Vehicle")
                .font(.headline)
            
            HStack {
                Image(systemName: "truck.box.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("Vehicle #PB10AB0505")
                        .font(.subheadline)
                        .bold()
                    Text("2019 Bharat Benz")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3)
    }
}

#Preview {
    AssignedVehicleView()
}
