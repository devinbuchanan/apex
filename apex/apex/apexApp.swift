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
    @StateObject private var health = HealthKitService.shared
    @StateObject private var sync = SyncService.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if auth.isSignedIn {
                if hasCompletedOnboarding {
                    MainTabView()
                        .environment(\.managedObjectContext, stack.context)
                        .environmentObject(auth)
                        .environmentObject(health)
                        .environmentObject(sync)
                } else {
                    OnboardingView()
                        .environment(\.managedObjectContext, stack.context)
                        .environmentObject(auth)
                        .environmentObject(health)
                        .environmentObject(sync)
                }
            } else {
                SignInView()
                    .environmentObject(auth)
                    .environmentObject(health)
                    .environmentObject(sync)
            }
        }
    }
}
