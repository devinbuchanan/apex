//
//  apexApp.swift
//  apex
//
//  Created by Devin Buchanan on 6/13/25.
//

import SwiftUI
import CoreData

@main
struct apexApp: App {
    private let stack = CoreDataStack.shared
    @StateObject private var auth = AuthViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if auth.isSignedIn {
                if hasCompletedOnboarding {
                    MainTabView()
                        .environment(\.managedObjectContext, stack.context)
                        .environmentObject(auth)
                } else {
                    OnboardingView()
                        .environment(\.managedObjectContext, stack.context)
                        .environmentObject(auth)
                }
            } else {
                SignInView()
                    .environmentObject(auth)
            }
        }
    }
}
