import Foundation
import CoreData

@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var age: Int16
    @NSManaged public var currentWeight: Double
    @NSManaged public var startingWeight: Double
    @NSManaged public var goalWeight: Double
    @NSManaged public var bodyFatPercentage: Double
    @NSManaged public var height: Double
    @NSManaged public var joinDate: Date
    @NSManaged public var gender: String?
    @NSManaged public var goal: String?
    @NSManaged public var activityLevel: String?
    @NSManaged public var dietaryPreferences: String?
    @NSManaged public var usesGLP1: Bool
    @NSManaged public var coachPersonality: String?
    @NSManaged public var onboardingStep: Int16
    @NSManaged public var hasCompletedOnboarding: Bool
    @NSManaged public var accountType: String?
}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    func toModel() -> UserProfileModel {
        UserProfileModel(
            id: id,
            name: name,
            age: Int(age),
            gender: gender ?? "",
            height: height,
            startingWeight: startingWeight,
            currentWeight: currentWeight,
            goalWeight: goalWeight,
            bodyFatPercentage: bodyFatPercentage,
            activityLevel: activityLevel ?? "",
            usesGLP1: usesGLP1,
            dietaryPreferences: dietaryPreferences ?? "",
            coachType: coachPersonality ?? "",
            accountType: accountType ?? "guest"
        )
    }

    func update(from model: UserProfileModel) {
        id = model.id
        name = model.name
        age = Int16(model.age)
        gender = model.gender
        height = model.height
        startingWeight = model.startingWeight
        currentWeight = model.currentWeight
        goalWeight = model.goalWeight
        bodyFatPercentage = model.bodyFatPercentage ?? 0
        activityLevel = model.activityLevel
        usesGLP1 = model.usesGLP1
        dietaryPreferences = model.dietaryPreferences
        coachPersonality = model.coachType
        accountType = model.accountType
    }
}
extension UserProfile: Identifiable {}
