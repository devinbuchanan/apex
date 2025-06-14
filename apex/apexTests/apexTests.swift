//
//  apexTests.swift
//  apexTests
//
//  Created by Devin Buchanan on 6/13/25.
//

import Testing
import CoreData
@testable import apex

struct apexTests {

    @Test func coreDataAddDelete() async throws {
        let container = NSPersistentCloudKitContainer(name: "TestModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
        let context = container.viewContext

        let profile = UserProfile(context: context)
        profile.id = UUID()
        profile.name = "Test"
        profile.age = 30
        profile.currentWeight = 150
        profile.startingWeight = 150
        profile.goalWeight = 150
        profile.bodyFatPercentage = 0
        profile.height = 180
        profile.joinDate = Date()
        try context.save()

        let fetch = try context.fetch(UserProfile.fetchRequest())
        #expect(fetch.count == 1)

        context.delete(profile)
        try context.save()

        let fetch2 = try context.fetch(UserProfile.fetchRequest())
        #expect(fetch2.isEmpty)
    }

}
