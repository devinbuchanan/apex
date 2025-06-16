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

    @Test func userProfileModelInit() async throws {
        // Test default initialization
        let defaultProfile = UserProfileModel()
        #expect(defaultProfile.name == "")
        #expect(defaultProfile.age == 0)
        #expect(defaultProfile.accountType == "guest")
        #expect(defaultProfile.syncHealthKit == false)
        #expect(defaultProfile.usesGLP1 == false)
        
        // Test that ID is generated
        #expect(defaultProfile.id.uuidString.count > 0)
    }

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
        profile.syncHealthKit = false
        try context.save()

        let fetch = try context.fetch(UserProfile.fetchRequest())
        #expect(fetch.count == 1)

        context.delete(profile)
        try context.save()

        let fetch2 = try context.fetch(UserProfile.fetchRequest())
        #expect(fetch2.isEmpty)
    }

    @Test func healthKitServiceInit() async throws {
        // Test HealthKitService singleton initialization
        let healthService = HealthKitService.shared
        #expect(healthService.stepsToday == 0)
        #expect(healthService.workouts.isEmpty)
        #expect(healthService.sleep.isEmpty)
        #expect(healthService.hydration == 0)
        #expect(healthService.isAuthorized == false)
    }

    @Test func syncServiceInit() async throws {
        // Test SyncService singleton initialization
        let syncService = SyncService.shared
        #expect(syncService.cloudKitLastSync == nil)
        #expect(syncService.cloudKitError == nil)
        #expect(syncService.healthKitLastSync == nil)
    }

    @Test func coreDataStackInit() async throws {
        // Test CoreDataStack singleton initialization
        let stack = CoreDataStack.shared
        #expect(stack.context != nil)
        
        // Verify managed object model has expected entities
        let model = stack.context.persistentStoreCoordinator?.managedObjectModel
        #expect(model != nil)
        
        let entityNames = model?.entities.compactMap { $0.name } ?? []
        #expect(entityNames.contains("UserProfile"))
        #expect(entityNames.contains("FoodLog"))
        #expect(entityNames.contains("WorkoutLog"))
        #expect(entityNames.contains("HabitLog"))
        #expect(entityNames.contains("Award"))
    }

}
