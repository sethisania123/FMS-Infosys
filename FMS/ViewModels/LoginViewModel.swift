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
    
    // Check if any users exist in Firestore
    func checkIfFirstUser() {
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    return
                }
                
                // If no users exist, set isFirstUser to true
                self.isFirstUser = snapshot?.documents.isEmpty ?? true
            }
        }
    }
    
    // Sign in with email and password
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        auth.signIn(withEmail: email, password: password) { [weak self] (authResult: AuthDataResult?, error: Error?) in
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
    
    // Create a Fleet Manager account
    func createFleetManagerAccount(email: String, password: String, name: String, phone: String) {
        isLoading = true
        errorMessage = nil
        
        auth.createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
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
                    "role": Role.fleet.rawValue
                ]
                
                self.db.collection("users").document(userId).setData(userData) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                    } else {
                        print("Fleet Manager account created successfully!")
                        self.isFirstUser = false // Hide the "Create Fleet Manager Account" button
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    // Fetch user data from Firestore
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] (snapshot: DocumentSnapshot?, error: Error?) in
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
                        // First get the role to determine user type
                        guard let roleString = documentData["role"] as? String,
                              let role = Role(rawValue: roleString) else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid role data"])
                        }
                        
                        if role == .driver {
                            // Fetch additional driver data
                            self.fetchDriverData(userId: userId, userData: documentData)
                        } else {
                            // Create basic user
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
    
    // Fetch additional driver data from Firestore
    private func fetchDriverData(userId: String, userData: [String: Any]) {
        db.collection("drivers").document(userId).getDocument { [weak self] (snapshot: DocumentSnapshot?, error: Error?) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                do {
                    if let driverData = snapshot?.data() {
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
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid driver data"])
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
    
    // Create a User object from Firestore data
    private func createUser(from data: [String: Any]) throws -> User {
        guard let name = data["name"] as? String,
              let email = data["email"] as? String,
              let phone = data["phone"] as? String,
              let roleString = data["role"] as? String,
              let role = Role(rawValue: roleString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }
        
        return User(name: name, email: email, phone: phone, role: role)
    }
    
    // Set navigation destination based on user role
    private func setNavigationDestination(for role: Role) {
        switch role {
        case .fleet:
            self.navigationDestination = "FleetDashboard"
        case .driver:
            self.navigationDestination = "DriverDashboard"
        case .maintenance:
            self.navigationDestination = "MaintenanceDashboard"
        }
    }
}
