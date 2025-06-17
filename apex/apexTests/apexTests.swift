//
//  apexTests.swift
//  apexTests
//
//  Created by Devin Buchanan on 6/13/25.
//

import Testing
import CoreData
@testable import apex

/// Test suite for the Apex iOS app
/// Validates core functionality including CoreData operations and model conversions
struct apexTests {
    
    // Helper function to create test CoreData context
    private func createTestContext() -> NSManagedObjectContext {
        let model = TestModelHelper.createTestModel()
        let container = NSPersistentCloudKitContainer(name: "TestModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
        return container.viewContext
    }

    @Test func coreDataAddDelete() async throws {
        let context = createTestContext()

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
    
    @Test func userProfileModelConversion() async throws {
        let context = createTestContext()
        
        // Create a UserProfile
        let profile = UserProfile(context: context)
        let testId = UUID()
        profile.id = testId
        profile.name = "Test User"
        profile.age = 25
        profile.currentWeight = 70.5
        profile.startingWeight = 75.0
        profile.goalWeight = 65.0
        profile.bodyFatPercentage = 15.0
        profile.height = 175.0
        profile.joinDate = Date()
        profile.gender = "male"
        profile.activityLevel = "moderate"
        profile.dietaryPreferences = "vegetarian"
        profile.coachPersonality = "supportive"
        profile.accountType = "full"
        profile.syncHealthKit = true
        profile.usesGLP1 = false
        
        // Test conversion to model
        let userModel = profile.toModel()
        #expect(userModel.id == testId)
        #expect(userModel.name == "Test User")
        #expect(userModel.age == 25)
        #expect(userModel.currentWeight == 70.5)
        #expect(userModel.startingWeight == 75.0)
        #expect(userModel.goalWeight == 65.0)
        #expect(userModel.bodyFatPercentage == 15.0)
        #expect(userModel.height == 175.0)
        #expect(userModel.gender == "male")
        #expect(userModel.activityLevel == "moderate")
        #expect(userModel.dietaryPreferences == "vegetarian")
        #expect(userModel.coachType == "supportive")
        #expect(userModel.accountType == "full")
        #expect(userModel.syncHealthKit == true)
        #expect(userModel.usesGLP1 == false)
    }

}
