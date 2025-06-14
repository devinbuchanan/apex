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

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, stack.context)
        }
    }
}
