import Foundation
import CoreData

@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var age: Int16
    @NSManaged public var weight: Double
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
}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }
}
extension UserProfile: Identifiable {}
