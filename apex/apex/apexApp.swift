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
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
                    .environment(\.managedObjectContext, stack.context)
            } else {
                OnboardingView()
                    .environment(\.managedObjectContext, stack.context)
            }
        }
    }
}
