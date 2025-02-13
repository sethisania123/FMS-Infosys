//
//  logInScreen.swift
//  FMS
//
//  Created by Ankush Sharma on 12/02/25.
//
import SwiftUI
import FirebaseFirestore

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    @State private var isPageChangeing: Bool = false
    
    func HandleLogin() -> Void {
        
        
        
        print("Function started")
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let error = err {
                print(err?.localizedDescription ?? "eror here")
            } else {
                for doc in querySnapshot!.documents {
                    let data = doc.data()
                    
                    if data["email"] as! String == self.email && data["password"] as! String == self.password {
                        
                        self.isPageChangeing = true
                    } else {
                        print("Login Failed")
                    }
                }
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
                
                // MARK: Sign In Button
                Button(action: {
                    self.HandleLogin()
//                    viewModel.signIn(email: email, password: password)
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
                
                
                // Create Fleet Manager Account Button (Visible only if no users exist)
                if viewModel.isFirstUser {
                    Button(action: {
                        viewModel.createFleetManagerAccount(email: "fleetmanager@example.com", password: "password123", name: "John Doe", phone: "123-456-7890")
                    }) {
                        Text("Create Fleet Manager Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [Color.green, Color.green.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                }
                
//                // Navigation Links
//                Group {
//                    NavigationLink(
//                        destination: FleetControlDashboard().navigationBarHidden(true),
//                        tag: "FleetDashboard",
//                        selection: $viewModel.navigationDestination
//                    ) { EmptyView() }
//                    
//                    NavigationLink(
//                        destination: FleetControlDashboard().navigationBarHidden(true),
//                        tag: "DriverDashboard",
//                        selection: $viewModel.navigationDestination
//                    ) { EmptyView() }
//                    
//                    NavigationLink(
//                        destination: FleetControlDashboard().navigationBarHidden(true),
//                        tag: "MaintenanceDashboard",
//                        selection: $viewModel.navigationDestination
//                    ) { EmptyView() }
//                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .navigationDestination(isPresented: self.$isPageChangeing){
                FleetControlDashboard()
                    .navigationBarBackButtonHidden()
            }
//            .alert(isPresented: $viewModel.showError) {
//                Alert(
//                    title: Text("Message"),
//                    message: Text(viewModel.errorMessage ?? "An error occurred"),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
        }
    }
}

#Preview {
    LoginView()
}
