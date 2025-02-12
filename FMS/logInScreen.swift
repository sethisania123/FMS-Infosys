//
//  logInScreen.swift
//  FMS
//
//  Created by Ankush Sharma on 12/02/25.
//
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView{
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
                
                // Welcome Message
//                Text("Welcome Back")
//                    .font(.headline)
//                    .fontWeight(.bold)
                
//                Text("Sign in to manage your fleet")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
                
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
                        
                        // Show password in TextField if isPasswordVisible is true, otherwise use SecureField
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Enter your password", text: $password)
                        }
                        
                        // Eye icon to toggle password visibility
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye") // Change the icon based on visibility
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
                NavigationLink(destination: FleetControlDashboard().navigationBarHidden(true)) {
                    
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                }
                .disabled(email.isEmpty || password.isEmpty)
                .opacity((email.isEmpty || password.isEmpty) ? 0.5 : 1)
                
                Spacer()
            }
            
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
    }
}

#Preview {
    LoginView()
}
