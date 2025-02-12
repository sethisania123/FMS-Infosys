//
//  addNewTripform.swift
//  FMS
//
//  Created by Ankush Sharma on 12/02/25.
//
import SwiftUI

struct AddNewTripView: View {
    @State private var fromLocation: String = ""
    @State private var toLocation: String = ""
    @State private var selectedGeoArea: String = "Select Area"
    @State private var deliveryDate: Date = Date()
    @State private var geoAreas = ["Area 1", "Area 2", "Area 3"]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Enter pickup location", text: $fromLocation)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                            .overlay(
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            )
                        
                        TextField("Enter destination", text: $toLocation)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                            .overlay(
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            )
                    }
                    
                    Section {
                        Picker(selection: $selectedGeoArea, label:
                            HStack {
                                Text(selectedGeoArea)
                                Spacer()
//                                Image(systemName: "chevron.down")
//                                    .foregroundColor(.gray)
                            }
                        ) {
                            ForEach(geoAreas, id: \.self) { area in
                                Text(area).tag(area)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Section {
                        DatePicker("", selection: $deliveryDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                            .overlay(
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            )
                    }
                }
                
                Button(action: {
                    print("Create Trip tapped")
                }) {
                    Text("Create Trip")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Add New Trip", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {}, trailing: Button("Save") {})
        }
    }
}

struct AddNewTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTripView()
    }
}
