//
//  AddUserForm.swift
//  FMS
//
//  Created by Ankush Sharma on 12/02/25.
//

import SwiftUI
import Cloudinary
import SwiftSMTP

struct FMSCloudinaryConfig {
    static let cloudName = "dztmc60fg"
    static let uploadPreset = "FMS-iNFOSYS"
    static let apiKey = "489983833873463"
}

struct FMSCloudinaryResponse: Codable {
    let secureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case secureUrl = "secure_url"
    }
}

let config = CLDConfiguration(cloudName: FMSCloudinaryConfig.cloudName, apiKey: FMSCloudinaryConfig.apiKey)
let cloudinary = CLDCloudinary(configuration: config)

func sendEmail(to email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    let smtp = SMTP(
        hostname: "smtp.gmail.com",  // Change this for Outlook, Yahoo, etc.
        email: "sohamchakraborty18.edu@gmail.com",  // Replace with your sender email
        password: "nvyanzllnqpudxha", // Use App Password (not Gmail password)
        port: 465, // Use 587 for TLS
        tlsMode: .requireTLS
    )

    let from = Mail.User(name: "Team 5", email: "sohamchakraborty18.edu@gmail.com")
    let to = Mail.User(name: "User", email: email)

    let mail = Mail(
                from: from,
                to: [to],
                subject: "Your Login Credentials",
                text: """
                The login credentials for your account are as follows:
                
                Email: \(email)
                Password: \(password)
                
                Best regards,
                Team 5
                """
            )

    smtp.send(mail) { error in
        if let error = error {
            completion(false, "Error sending email: \(error.localizedDescription)")
        } else {
            completion(true, "Login credentials sent successfully to \(email)")
        }
    }
}

struct AddUserForm: View {
    var body: some View {
        AddUserView()
    }
}

struct AddUserView: View {
    @State private var selectedRole = "Fleet Manager"
    @State private var name = ""
    @State private var email = ""
    @State private var contactNumber = ""
    @State private var generatedPassword: String = ""
    @State private var showPassword: Bool = false
    
    @State private var licenseNumber = ""
    @State private var selectedExperience: Experience = .lessThanOne
    @State private var selectedVehicleType: VehicleType = .truck
    @State private var selectedGeoArea: GeoPreference = .plain
    
    @State private var licensePhoto: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isFormValid = false
    @State private var nameError: String? = nil
    @State private var phoneError: String? = nil
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
  
    let roles = ["Fleet Manager", "Driver", "Maintenance"]
    
    
    var experiencePicker: some View {
        Menu {
            ForEach(Experience.allCases, id: \.self) { exp in
                Button(exp.rawValue) {
                    selectedExperience = exp
                }
            }
        } label: {
            HStack {
                Text(selectedExperience.rawValue)
                    .foregroundColor(selectedExperience == .lessThanOne ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.all,2)
            .background(Color(.white))
            .cornerRadius(8)
        }
    
    }
    
    var vehicleTypePicker: some View {
        Menu {
            ForEach(VehicleType.allCases, id: \.self) { type in
                Button(type.rawValue) {
                    selectedVehicleType = type
                }
            }
        } label: {
            HStack {
                Text(selectedVehicleType.rawValue)
                    .foregroundColor(selectedVehicleType == .truck ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.all,2)
            .background(Color(.white))
            .cornerRadius(8)
        }
    }
    
    var geoAreaPicker: some View {
        Menu {
            ForEach(GeoPreference.allCases, id: \.self) { exp in
                Button(exp.rawValue) {
                    selectedGeoArea = exp
                }
            }
        } label: {
            HStack {
                Text(selectedGeoArea.rawValue)
                    .foregroundColor(selectedGeoArea == .plain ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.all,2)
            .background(Color(.white))
            .cornerRadius(8)
        }
    }
    private var isButtonDisabled: Bool {
        return isLoading || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               contactNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    var body: some View {
//        NavigationView {
            VStack {
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
                    if selectedRole == "Fleet Manager" {
                        
                        Section(header: Text("Name").font(.headline)
                                            .padding(.leading, -22)) {
                                    TextField("Enter your name", text: $name)
                                        .onChange(of: name) { newValue in
                                            name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                            
                                            if !name.isEmpty && !isValidName(name) {
                                                nameError = "Name should only contain letters"
                                            } else {
                                                nameError = nil
                                            }
                                        }
                                        .padding(5)
                                        .background(Color.clear)
                                        .frame(height: 47)
                                        .listRowBackground(Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .frame(width: 361)
                                    
                                    if let error = nameError {
                                        Text(error)
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                        Section(header: Text("Email").font(.headline).padding(.leading, -22)) {
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
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
                                .onChange(of: contactNumber) { newValue in
                                    if !newValue.isEmpty && !isValidPhone(newValue) {
                                        phoneError = "Phone number should be 10 digits"
                                    } else {
                                        phoneError = nil
                                    }
                                    contactNumber = newValue.filter { "0123456789".contains($0) }
                                    if contactNumber.count > 10 {
                                        contactNumber = String(contactNumber.prefix(10))
                                    }
                                }
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
                            if let error = phoneError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        Section {
                            Button(action: {
                                validateForm()
                            }) {
                                Text("Create Account")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                          
                            .disabled(isButtonDisabled)
                            .opacity((isButtonDisabled) ? 0.5 : 1)

                        }
                        .listRowBackground(Color.clear)
                    }
                    
                    if selectedRole == "Driver" {
                        Section(header: Text("Name").font(.headline)
                            .padding(.leading, -22)) {
                                TextField("Enter your name", text: $name)
                                    .onChange(of: name) { newValue in
                                        if !newValue.isEmpty && !isValidName(newValue) {
                                            nameError = "Name should only contain letters"
                                        } else {
                                            nameError = nil
                                        }
                                    }
                                    .padding(5)
                                    .background(Color.clear)
                                    .frame(height: 47)
                                    .listRowBackground(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .frame(width:361)
                                if let error = nameError {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        
                        Section(header: Text("Email").font(.headline).padding(.leading, -22)) {
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
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
                                .onChange(of: contactNumber) { newValue in
                                    if !newValue.isEmpty && !isValidPhone(newValue) {
                                        phoneError = "Phone number should be 10 digits"
                                    } else {
                                        phoneError = nil
                                    }
                                    contactNumber = newValue.filter { "0123456789".contains($0) }
                                    if contactNumber.count > 10 {
                                        contactNumber = String(contactNumber.prefix(10))
                                    }
                                }
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
                            if let error = phoneError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
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
                            experiencePicker
                        }
                        
                        
                        Section(header: Text("Type of Vehicle").font(.headline).padding(.leading, -22)) {
                            vehicleTypePicker
                        }
                        
                        Section(header: Text("Specialization in Geo Areas").font(.headline).padding(.leading, -22)) {
                            geoAreaPicker
                        }
                        Section {
                            Button(action: {
                                validateForm()
                            }) {
                                Text("Create Account")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .disabled(isLoading || name.isEmpty || email.isEmpty || contactNumber.isEmpty)
                            .opacity((email.isEmpty || name.isEmpty || contactNumber.isEmpty) ? 0.5 : 1)
                        }
                        .listRowBackground(Color.clear)
                    }
                    if selectedRole == "Maintenance" {
                        
                        Section(header: Text("Name").font(.headline)
                            .padding(.leading, -22)) {
                                TextField("Enter your name", text: $name)
                                    .onChange(of: name) { newValue in
                                        if !newValue.isEmpty && !isValidName(newValue) {
                                            nameError = "Name should only contain letters"
                                        } else {
                                            nameError = nil
                                        }
                                    }
                                    .padding(5)
                                    .background(Color.clear)
                                    .frame(height: 47)
                                    .listRowBackground(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .frame(width:361)
                                if let error = nameError {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        
                        Section(header: Text("Email").font(.headline).padding(.leading, -22)) {
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
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
                                .onChange(of: contactNumber) { newValue in
                                    if !newValue.isEmpty && !isValidPhone(newValue) {
                                        phoneError = "Phone number should be 10 digits"
                                    } else {
                                        phoneError = nil
                                    }
                                    contactNumber = newValue.filter { "0123456789".contains($0) }
                                    if contactNumber.count > 10 {
                                        contactNumber = String(contactNumber.prefix(10))
                                    }
                                }
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
                            if let error = phoneError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        
                        Section {
                            Button(action: {
                               validateForm()
                            }) {
                                Text("Create Account")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .disabled(isLoading||name.isEmpty || email.isEmpty || contactNumber.isEmpty)
                            .opacity((name.isEmpty || email.isEmpty || contactNumber.isEmpty) ? 0.5 : 1)
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                    
                    
                   
                }
                
                if isLoading {
                    ProgressView("Creating account...")
                        .padding()
                }
            }
            .navigationTitle("Add New User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
//        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $licensePhoto)
        }
        
       
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Account Creation"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func isValidName(_ name: String) -> Bool {
            let nameRegex = "^[a-zA-Z ]+$"
            let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            return namePredicate.evaluate(with: name)
        }
        
    private func isValidPhone(_ phone: String) -> Bool {
            let phoneRegex = "^[0-9]{10}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: phone)
        }
    private func generateSecurePassword() -> String {
        let length = 12
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    private func validateForm() {
        // Validate required fields
        guard !name.isEmpty && !email.isEmpty && !contactNumber.isEmpty else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
            return
        }
        
        // Email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            alertMessage = "Please enter a valid email address"
            showingAlert = true
            return
        }
        
        isLoading = true
//        let loginModel_t = LoginViewModel()
        generatedPassword = generateSecurePassword()
        
        // Create account
        if selectedRole == "Driver" {
            // Create driver account
            let loginModel_t = LoginViewModel()
            loginModel_t.createDriverAccount(
                name: self.name,
                email: self.email, 
                password: generatedPassword,
                phone: contactNumber,
                experience: selectedExperience,
                license: licenseNumber,
                geoPreference: selectedGeoArea,
                vehiclePreference: selectedVehicleType
            )
            uploadLicensePhotoToCloudinary()
        } else if selectedRole == "Fleet Manager" {
            // Create fleet manager account
            let loginModel_t = LoginViewModel()
            loginModel_t.createFleetManagerAccount(
                email: self.email,
                password: generatedPassword,
                name: self.name,
                phone: contactNumber
            )
        } else if selectedRole == "Maintenance" {
            let loginModel_t = LoginViewModel()
            loginModel_t.createMaintenanceAccount(
                email: self.email,
                password: generatedPassword,
                name: self.name,
                phone: contactNumber
            )
        }
        
        // Send email with credentials
//        sendEmail(to: self.email, name: self.name, password: generatedPassword)
        sendEmail(to: self.email, password: generatedPassword) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.alertMessage = message
                self.showingAlert = true
            }
        }
    }
    
    func uploadLicensePhotoToCloudinary() {
        guard let image = licensePhoto else { return }
        
        isLoading = true
        
        cloudinary.createUploader().upload(data: image.jpegData(compressionQuality: 0.8)!, uploadPreset: "FMS-iNFOSYS", completionHandler:  { (result, error) in
            if let error = error {
                print("❌ Error uploading photo: \(error.localizedDescription)")
                alertMessage = "Failed to upload photo"
                showingAlert = true
            } else if let _ = result {
                print("✅ Photo uploaded successfully")
                alertMessage = "Photo uploaded successfully!"
                showingAlert = true
            }
            isLoading = false
        })
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
