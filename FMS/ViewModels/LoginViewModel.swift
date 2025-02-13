import FirebaseAuth
import FirebaseFirestore
import Foundation

class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var authenticatedUser: User?
    @Published var navigationDestination: String?
    @Published var isFirstUser: Bool = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        checkIfFirstUser()
    }
    
    func checkIfFirstUser() {
        db.collection("users").whereField("role", isEqualTo: Role.fleet.rawValue)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                        return
                    }
                    self?.isFirstUser = snapshot?.isEmpty ?? true
                }
            }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required"
            showError = true
            isLoading = false
            return
        }
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    self.errorMessage = "User ID not found"
                    self.showError = true
                    self.isLoading = false
                    return
                }
                
                self.fetchUserData(userId: userId)
            }
        }
    }
    
    func createFleetManagerAccount(email: String, password: String, name: String, phone: String) {
        isLoading = true
        errorMessage = nil
        
        
        let userDataDict = ["email": email, "name": name, "phone": phone, "role": Role.fleet.rawValue] as [String : Any]
        let database = Firestore.firestore()
        let newUserCollectionRef = database.collection("users").document(UUID().uuidString)
        newUserCollectionRef.setData(userDataDict)
        
        self.isLoading = false
        
    }
    
    func createDriverAccount(name: String, email: String, phone: String, experience: Experience,
                           license: String, geoPreference: GeoPreference, vehiclePreference: VehicleType) {
        isLoading = true
        errorMessage = nil
        
        // Input validation
        guard !email.isEmpty, !name.isEmpty, !phone.isEmpty, !license.isEmpty else {
            errorMessage = "All fields are required"
            showError = true
            isLoading = false
            return
        }
        
        // Generate a secure random password
        let password = generateSecurePassword()
        
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    self.errorMessage = "User ID not found"
                    self.showError = true
                    self.isLoading = false
                    return
                }
                
                let userData: [String: Any] = [
                    "name": name,
                    "email": email,
                    "phone": phone,
                    "role": Role.driver.rawValue,
                    "createdAt": Timestamp()
                ]
                
                self.createDriverProfile(userId: userId, userData: userData, driverData: [
                    "experience": experience.rawValue,
                    "license": license,
                    "geoPreference": geoPreference.rawValue,
                    "vehiclePreference": vehiclePreference.rawValue,
                    "status": true,
                    "createdAt": Timestamp()
                ], password: password)
            }
        }
    }
    
    private func createDriverProfile(userId: String, userData: [String: Any], driverData: [String: Any], password: String) {
        let batch = db.batch()
        
        let userRef = db.collection("users").document(userId)
        let driverRef = db.collection("drivers").document(userId)
        
        batch.setData(userData, forDocument: userRef)
        batch.setData(driverData, forDocument: driverRef)
        
        batch.commit { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                } else {
                    // Here you would typically send an email to the driver with their credentials
                    print("Driver account created successfully with email: \(userData["email"] as? String ?? "") and password: \(password)")
                }
                self?.isLoading = false
            }
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                    return
                }
                
                do {
                    if let documentData = snapshot?.data() {
                        guard let roleString = documentData["role"] as? String,
                              let role = Role(rawValue: roleString) else {
                            throw NSError(domain: "", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid role data"])
                        }
                        
                        if role == .driver {
                            self.fetchDriverData(userId: userId, userData: documentData)
                        } else {
                            let user = try self.createUser(from: documentData)
                            user.id = userId
                            self.authenticatedUser = user
                            self.setNavigationDestination(for: role)
                            self.isLoading = false
                        }
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchDriverData(userId: String, userData: [String: Any]) {
        db.collection("drivers").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                do {
                    if let driverData = snapshot?.data() {
                        let driver = try self.createDriver(userId: userId, userData: userData, driverData: driverData)
                        self.authenticatedUser = driver
                        self.setNavigationDestination(for: .driver)
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
                self.isLoading = false
            }
        }
    }
    
    private func createDriver(userId: String, userData: [String: Any], driverData: [String: Any]) throws -> Driver {
        guard let name = userData["name"] as? String,
              let email = userData["email"] as? String,
              let phone = userData["phone"] as? String,
              let experienceString = driverData["experience"] as? String,
              let experience = Experience(rawValue: experienceString),
              let license = driverData["license"] as? String,
              let geoPreferenceString = driverData["geoPreference"] as? String,
              let geoPreference = GeoPreference(rawValue: geoPreferenceString),
              let vehiclePreferenceString = driverData["vehiclePreference"] as? String,
              let vehiclePreference = VehicleType(rawValue: vehiclePreferenceString),
              let status = driverData["status"] as? Bool else {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Invalid driver data"])
        }
        
        let driver = Driver(
            name: name,
            email: email,
            phone: phone,
            experience: experience,
            license: license,
            geoPreference: geoPreference,
            vehiclePreference: vehiclePreference,
            status: status
        )
        driver.id = userId
        return driver
    }
    
    private func createUser(from data: [String: Any]) throws -> User {
        guard let name = data["name"] as? String,
              let email = data["email"] as? String,
              let phone = data["phone"] as? String,
              let roleString = data["role"] as? String,
              let role = Role(rawValue: roleString) else {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }
        
        return User(name: name, email: email, phone: phone, role: role)
    }
    
    private func setNavigationDestination(for role: Role) {
        switch role {
        case .fleet:
            navigationDestination = "FleetDashboard"
        case .driver:
            navigationDestination = "DriverDashboard"
        case .maintenance:
            navigationDestination = "MaintenanceDashboard"
        }
    }
    
    private func generateSecurePassword() -> String {
        let length = 12
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}
