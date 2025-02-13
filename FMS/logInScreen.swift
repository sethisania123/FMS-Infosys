import SwiftUI
import FirebaseFirestore

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isPageChanging: Bool = false
    @State private var userRole: Role? = nil

    func HandleLogin() {
        print("Function started")
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let error = err {
                print(err?.localizedDescription ?? "error here")
            } else {
                for doc in querySnapshot!.documents {
                    let data = doc.data()
                    
                    if data["email"] as! String == self.email && data["password"] as! String == self.password {
                        if let roleString = data["role"] as? String, let role = Role(rawValue: roleString) {
                            self.userRole = role
                            self.isPageChanging = true
                        }
                        return // Exit the loop once a match is found
                    }
                }
                print("Login Failed")
            }
        }
        
        print("Function ended")
    }
   
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // App Icon
                Image(systemName: "square.grid.2x2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                // App Name
                Text("Fleet Pro")
                    .font(.title)
                    .fontWeight(.semibold)
                
                // Email Field
                VStack {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Enter your email", text: $email)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Password Field
                VStack {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Enter your password", text: $password)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Forgot Password
                HStack {
                    Spacer()
                    Text("Forgot Password?")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                        .padding(.trailing)
                }
                
                // Sign In Button
                Button(action: {
                    self.HandleLogin()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [Color.blue, Color.blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .disabled(email.isEmpty || password.isEmpty || viewModel.isLoading)
                .opacity((email.isEmpty || password.isEmpty) ? 0.5 : 1)
                
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .navigationDestination(isPresented: self.$isPageChanging) {
                if let role = userRole {
                    switch role {
                    case .driver:
                        MainTabView()
                            .navigationBarBackButtonHidden()
                    case .fleet:
                        FleetControlDashboard()
                            .navigationBarBackButtonHidden()
                    case .maintenance:
                        MainTabView()
                            .navigationBarBackButtonHidden()
                    }
                }
            }
        }
    }
}

#Preview {
//    LoginView()
    
}
