import SwiftUI
import AuthenticationServices

struct UpgradeAccountView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Upgrade your account")
                .font(.headline)

            SignInWithAppleButton(.continue) { _ in } onCompletion: { _ in
                auth.signInWithApple()
                auth.upgradeFromGuest()
                dismiss()
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
                auth.upgradeFromGuest()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    UpgradeAccountView().environmentObject(AuthViewModel())
}
