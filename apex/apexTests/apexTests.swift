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
    
    // Helper function to create a test CoreData model matching the app's model
    private func createTestModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        func attribute(name: String, type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let attr = NSAttributeDescription()
            attr.name = name
            attr.attributeType = type
            attr.isOptional = optional
            return attr
        }
        
        let user = NSEntityDescription()
        user.name = "UserProfile"
        user.managedObjectClassName = NSStringFromClass(UserProfile.self)
        user.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "name", type: .stringAttributeType),
            attribute(name: "age", type: .integer16AttributeType),
            attribute(name: "currentWeight", type: .doubleAttributeType),
            attribute(name: "startingWeight", type: .doubleAttributeType),
            attribute(name: "goalWeight", type: .doubleAttributeType),
            attribute(name: "bodyFatPercentage", type: .doubleAttributeType),
            attribute(name: "height", type: .doubleAttributeType),
            attribute(name: "joinDate", type: .dateAttributeType),
            attribute(name: "gender", type: .stringAttributeType, optional: true),
            attribute(name: "goal", type: .stringAttributeType, optional: true),
            attribute(name: "activityLevel", type: .stringAttributeType, optional: true),
            attribute(name: "dietaryPreferences", type: .stringAttributeType, optional: true),
            attribute(name: "usesGLP1", type: .booleanAttributeType),
            attribute(name: "coachPersonality", type: .stringAttributeType, optional: true),
            attribute(name: "onboardingStep", type: .integer16AttributeType),
            attribute(name: "hasCompletedOnboarding", type: .booleanAttributeType),
            attribute(name: "accountType", type: .stringAttributeType, optional: true),
            attribute(name: "syncHealthKit", type: .booleanAttributeType)
        ]
        
        model.entities = [user]
        return model
    }

    @Test func coreDataAddDelete() async throws {
        // Create a test model matching the app's model for consistent testing
        let model = createTestModel()
        
        let container = NSPersistentCloudKitContainer(name: "TestModel", managedObjectModel: model)
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
    
    @Test func userProfileModelConversion() async throws {
        // Test UserProfile to UserProfileModel conversion
        let model = createTestModel()
        
        let container = NSPersistentCloudKitContainer(name: "TestModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
        let context = container.viewContext
        
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
