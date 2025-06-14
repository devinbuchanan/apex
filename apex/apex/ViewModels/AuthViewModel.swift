import SwiftUI
import AuthenticationServices
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

final class AuthViewModel: NSObject, ObservableObject {
    @AppStorage("isSignedIn") private var storedSignedIn: Bool = false
    @AppStorage("isGuest") private var storedGuest: Bool = false

    @Published var isSignedIn: Bool = false
    @Published var isGuest: Bool = false

    override init() {
        super.init()
        isSignedIn = storedSignedIn
        isGuest = storedGuest
    }

    func signInWithApple() {
        // Real implementation would use ASAuthorizationController
        storedSignedIn = true
        storedGuest = false
        isSignedIn = true
        isGuest = false
    }

    func sendEmailLink(to email: String) {
        #if canImport(FirebaseAuth)
        let settings = ActionCodeSettings()
        settings.handleCodeInApp = true
        settings.url = URL(string: "https://example.com")
        settings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: settings) { error in
            if let error = error {
                print("Failed to send link: \(error.localizedDescription)")
            }
        }
        #else
        print("Sending email link to \(email)")
        #endif
    }

    func signInWithEmail(link: String, email: String) {
        #if canImport(FirebaseAuth)
        Auth.auth().signIn(withEmail: email, link: link) { [weak self] _, error in
            if let error = error {
                print("Email sign in failed: \(error.localizedDescription)")
            } else {
                self?.storedSignedIn = true
                self?.storedGuest = false
                self?.isSignedIn = true
                self?.isGuest = false
            }
        }
        #else
        storedSignedIn = true
        storedGuest = false
        isSignedIn = true
        isGuest = false
        #endif
    }

    func signInGuest() {
        storedSignedIn = true
        storedGuest = true
        isSignedIn = true
        isGuest = true
    }

    func upgradeFromGuest() {
        storedGuest = false
        isGuest = false
    }

    func signOut() {
        #if canImport(FirebaseAuth)
        try? Auth.auth().signOut()
        #endif
        storedSignedIn = false
        storedGuest = false
        isSignedIn = false
        isGuest = false
    }
}
