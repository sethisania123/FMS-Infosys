import SwiftUI

struct TripDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: { /* Go Back Action */ }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    Text("Back")
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Trip Details")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("From")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Pending Assignment")
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
                Text("123 Business Park, Los Angeles")
                    .font(.body)
                    .bold()
                Divider()
                
                Text("To")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("456 Industrial Zone, San Francisco")
                    .font(.body)
                    .bold()
                Divider()
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Delivery Date: Feb 15, 2024")
                }
                
                .font(.subheadline)
                Divider()
                
                HStack {
                    Image(systemName: "map")
                    Text("Geo Area")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text("Hilly area")
                    .font(.body)
                    .bold()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            HStack(spacing: 16) {
                Button(action: { /* Assign Driver Action */ }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Assign Driver")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: { /* Assign Vehicle Action */ }) {
                    HStack {
                        Image(systemName: "car.fill")
                        Text("Assign Vehicle")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Driver")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.gray)
                    Text("Not Assigned")
                        .foregroundColor(.gray)
                }
                
                Text("Vehicle")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "car.circle")
                        .foregroundColor(.gray)
                    Text("Not Assigned")
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading,-170)
            .frame(maxWidth: 500,maxHeight: 150)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            
            Spacer()
            
            Button(action: { /* Save Changes Action */ }) {
                Text("Save Changes")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView()
    }
}
