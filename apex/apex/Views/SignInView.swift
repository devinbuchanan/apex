import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var showGuestWarning = false

    var body: some View {
        VStack(spacing: 20) {
            SignInWithAppleButton(.signIn) { request in
                // configure request if needed
            } onCompletion: { _ in
                auth.signInWithApple()
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Send Magic Link") {
                auth.sendEmailLink(to: email)
            }
            .buttonStyle(.borderedProminent)

            Button("Continue as Guest") {
                showGuestWarning = true
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .alert("Guest Mode", isPresented: $showGuestWarning) {
            Button("Continue") { auth.signInGuest() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your data won’t sync or recover unless you upgrade.")
        }
    }
}

#Preview {
    SignInView().environmentObject(AuthViewModel())
}
