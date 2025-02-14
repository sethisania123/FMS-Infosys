//
//  ForgetPassword.swift
//  FMS
//
//  Created by Manav Gupta on 14/02/25.
//

import SwiftUI

struct ForgetPassword: View {
    @State private var email: String = ""

       var body: some View {
           VStack {
               // Back Button
               HStack {
                   Button(action: {
                       // Handle back action
                   }) {
                       Image(systemName: "chevron.left")
                           .font(.title2)
                           .foregroundColor(.black)
                   }
                   Spacer()
                   Text("Forgot Password")
                       .font(.headline)
                       .bold()
                   Spacer()
               }
               .padding()
               
               Spacer()
                   

               // Lock Image
               Image(systemName: "lock.fill")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 100, height: 100)
                   .foregroundColor(.blue)
                   .padding()
                   .background(Circle().fill(Color(red: 0/255, green: 122/255, blue: 255/255).opacity(0.1)).frame(width: 150, height: 150))

               Spacer()
                   .frame(height : 20)
               // Title
               Text("Reset Password")
                   .font(.title2)
                   .bold()
                   .padding(.top, 20)

               // Subtitle
               Text("Enter your email address and we'll send you instructions to reset your password")
                   .font(.body)
                   .foregroundColor(.gray)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 30)

               // Email Input Field
               HStack {
                   Image(systemName: "envelope")
                       .foregroundColor(.gray)
                   TextField("Enter your email address", text: $email)
                       .textFieldStyle(PlainTextFieldStyle())
               }
               .padding()
               .background(Color.gray.opacity(0.2))
               .cornerRadius(10)
               .padding(.horizontal, 30)
               .padding(.top, 20)

               // Send Reset Link Button
               Button(action: {
                   
                   
                   
               }) {
                   Text("Send Reset Link")
                       .bold()
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
               }
               .padding(.horizontal, 30)
               .padding(.top, 20)

               // Return to Login
               Button(action: {
                   // Handle return to login action
               }) {
                   Text("Return to Login")
                       .foregroundColor(.blue)
                       .padding(.top, 10)
               }

               Spacer()
           }
           .navigationBarHidden(true)
       }
}

#Preview {
    ForgetPassword()
}
