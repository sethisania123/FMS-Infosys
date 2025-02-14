import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftSMTP

// Assuming generateSecurePassword is defined in LoginViewModel.swift
// Example of generating a secure password (you can customize the logic)
func generateSecurePassword() -> String {
    // Generate a random password (You can implement your own logic here)
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
    var password = ""
    for _ in 0..<12 { // Generate a 12-character password
        password.append(characters.randomElement()!)
    }
    return password
}

func sendPassword(to email: String, password: String, completion: @escaping (Bool, String) -> Void) {
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
        text: "The login credentials for your account are as follows:\n\nEmail: \(email)\nPassword: \(password)"
    )

    smtp.send(mail) { error in
        if let error = error {
            completion(false, "Error sending email: \(error.localizedDescription)")
        } else {
            completion(true, "New password sent successfully to \(email)")
        }
    }
}

struct ForgetPassword: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
                .background(Circle().fill(Color.blue.opacity(0.1)).frame(width: 150, height: 150))

            Spacer().frame(height: 20)

            // Title
            Text("Reset Password")
                .font(.title2)
                .bold()
                .padding(.top, 20)

            // Subtitle
            Text("Enter your email address and we'll send you instructions to reset your password.")
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
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal, 30)
            .padding(.top, 20)

            // Send Reset Link Button
            Button(action: {
                // Start the password reset flow
                checkEmailInFirestore()
            }) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Send Reset Link")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .disabled(isLoading) // Disable button while loading

            Spacer()
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // This function will validate the email, check Firestore, and send the password reset link.
    func checkEmailInFirestore() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address."
            showAlert = true
            return
        }

        isLoading = true

        // Call the function to handle password reset
        handlePasswordReset(email: email) { success, message in
            isLoading = false
            alertMessage = message
            showAlert = true
        }
    }

    // Function to handle password reset
    func handlePasswordReset(email: String, completion: @escaping (Bool, String) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()

        // Query Firestore to check if the email exists in the "users" collection
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                // Handle Firestore error
                completion(false, "Error checking email: \(error.localizedDescription)")
                return
            }

            // If no user document is found for the email
            if snapshot?.documents.isEmpty ?? true {
                completion(false, "Email not found in our records.")
                return
            }

            // Email exists, generate a new password using the function
            let newPassword = generateSecurePassword()

            // Update Firestore with the new password
            if let document = snapshot?.documents.first {
                let userRef = db.collection("users").document(document.documentID)

                // Update the user's password in Firestore
                userRef.updateData(["password": newPassword]) { error in
                    if let error = error {
                        completion(false, "Error updating password: \(error.localizedDescription)")
                    } else {
                        // Successfully updated password, send it via email
                        sendPassword(to: email, password: newPassword) { success, message in
                            completion(success, message)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ForgetPassword()
}
