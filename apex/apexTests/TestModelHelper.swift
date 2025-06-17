//
//  TestModelHelper.swift
//  apexTests
//
//  Created by Devin Buchanan on 6/13/25.
//

import CoreData
@testable import apex

/// Helper functions for creating test CoreData models
struct TestModelHelper {
    
    /// Creates UserProfile entity properties for testing
    static func createUserProfileProperties() -> [NSPropertyDescription] {
        func attribute(name: String, type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let attr = NSAttributeDescription()
            attr.name = name
            attr.attributeType = type
            attr.isOptional = optional
            return attr
        }
        
        return [
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
    }
    
    /// Creates a test CoreData model matching the app's model
    static func createTestModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let user = NSEntityDescription()
        user.name = "UserProfile"
        user.managedObjectClassName = NSStringFromClass(UserProfile.self)
        user.properties = createUserProfileProperties()
        
        model.entities = [user]
        return model
    }
}