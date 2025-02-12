//
//  AddUserForm.swift
//  FMS
//
//  Created by Ankush Sharma on 12/02/25.
//

import SwiftUI

struct AddUserForm: View {
    var body: some View {
        AddUserView()
    }
}

struct AddUserView: View {
    @State private var selectedRole = "Fleet Manager"
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var contactNumber = ""
    
    @State private var licenseNumber = ""
    @State private var selectedExperience = "1-2 years"
    @State private var selectedVehicleType = "Truck"
    @State private var selectedGeoArea = "Urban"
    
    @State private var licensePhoto: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isFormValid = false
    @State private var isPasswordVisible: Bool = false
    
    let roles = ["Fleet Manager", "Driver", "Maintenance"]
    let experiences = ["1-2 years", "3-5 years", "5+ years"]
    let vehicleTypes = ["Truck", "Van", "Car"]
    let geoAreas = ["Urban", "Suburban", "Rural"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented Control
               
                

                Form {
                    Picker("Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top,10)
                    .padding(.leading,10)
                    .frame(width : 380)
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
                                  
                    Section(header: Text("Name").font(.headline)
                        .padding(.leading, -22)) {
                        
                        TextField("Enter your name", text: $name)
                            .padding(5)
                            .background(Color.clear)
                            .frame(height: 47)
                            
                            .listRowBackground(Color.clear)
                            .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                            .frame(width:361)

                          
                    }
                    
                    
                    Section(header: Text("Email").font(.headline).padding(.leading, -22)) {
                        
                        TextField("Enter your email", text: $email)
                        
                            .keyboardType(.emailAddress)
                            .padding(5)
                            .background(Color.clear)
                            .frame(height: 47)
                            
                            .listRowBackground(Color.clear)
                            .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                            .frame(width:361)
                    }
                    Section(header: Text("Password").font(.headline).padding(.leading, -22)) {
                        
                        SecureField("Enter password", text: $password)
                            .padding(5)
                            .background(Color.clear)
                            .frame(height: 47)
                            
                            .listRowBackground(Color.clear)
                            .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                            .frame(width:361)
                       
                    }
                    Section(header: Text("Contact Number").font(.headline).padding(.leading, -22)) {
                        
                        TextField("Enter contact number", text: $contactNumber)
                            .keyboardType(.phonePad)
                            .padding(5)
                            .background(Color.clear)
                            .frame(height: 47)
                            
                            .listRowBackground(Color.clear)
                            .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                            .frame(width:361)
                    }
                    
                    
                    // Show extra fields only for "Driver"
                    if selectedRole == "Driver" {
                        Section(header: Text("License Details").font(.headline).padding(.leading, -22)) {
                            TextField("Enter license number", text: $licenseNumber)
                                .padding(5)
                                .background(Color.clear)
                                .frame(height: 47)
                                
                                .listRowBackground(Color.clear)
                                .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.gray, lineWidth: 1)
                                                        )
                                .frame(width:361)
                            
                        }
                        Section(header: Text("License Photo").font(.headline).padding(.leading, -22)) {
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                HStack {
                                    Text("Upload License Photo")
                                    Spacer()
                                    if let _ = licensePhoto {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else {
                                        Text("Tap to upload")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        Section(header: Text("Experience (Years)").font(.headline).padding(.leading, -22)) {
                            Picker("Select Experience ", selection: $selectedExperience) {
                                ForEach(experiences, id: \.self) { exp in
                                    Text(exp).tag(exp)
                                }
                            }
                        }
                        Section(header: Text("Type of Vehicle").font(.headline).padding(.leading, -22)) {
                            
                            Picker("Select Vehicle", selection: $selectedVehicleType) {
                                ForEach(vehicleTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                        }
                        Section(header: Text("Specialization in Geo Areas").font(.headline).padding(.leading, -22)) {
                            
                            Picker("Select Specialization Areas", selection: $selectedGeoArea) {
                                ForEach(geoAreas, id: \.self) { area in
                                    Text(area).tag(area)
                                }
                            }
                        }
                    }
                    
                    
                    Section {
                        Button(action: {
                            validateForm()
                        }) {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue )
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
//                        .disabled(!isFormValid)
                    } .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Add New User")
            .toolbarBackground(Color.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $licensePhoto)
        }
//        .onChange(of: [name, email, password, contactNumber, licenseNumber]) { _ in
//            validateForm()
//        }
    }
    
    private func validateForm() {
        isFormValid = !name.isEmpty && !email.isEmpty && !password.isEmpty && !contactNumber.isEmpty
        if selectedRole == "Driver" {
            isFormValid = isFormValid && !licenseNumber.isEmpty
        }
    }
}

// Image Picker Component
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    AddUserForm()
}
