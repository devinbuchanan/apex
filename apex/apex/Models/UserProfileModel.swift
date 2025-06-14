import Foundation
import CloudKit

struct UserProfileModel: Identifiable, Codable {
    var id: UUID
    var name: String
    var age: Int
    var gender: String
    var height: Double
    var startingWeight: Double
    var currentWeight: Double
    var goalWeight: Double
    var bodyFatPercentage: Double?
    var activityLevel: String
    var usesGLP1: Bool
    var dietaryPreferences: String
    var coachType: String
    var accountType: String // guest or full
}

extension UserProfileModel {
    static let recordType = "UserProfile"

    init() {
        self.id = UUID()
        self.name = ""
        self.age = 0
        self.gender = ""
        self.height = 0
        self.startingWeight = 0
        self.currentWeight = 0
        self.goalWeight = 0
        self.bodyFatPercentage = nil
        self.activityLevel = ""
        self.usesGLP1 = false
        self.dietaryPreferences = ""
        self.coachType = ""
        self.accountType = "guest"
    }

    init?(record: CKRecord) {
        guard
            let name = record["name"] as? String,
            let age = record["age"] as? Int,
            let gender = record["gender"] as? String,
            let height = record["height"] as? Double,
            let startingWeight = record["startingWeight"] as? Double,
            let currentWeight = record["currentWeight"] as? Double,
            let goalWeight = record["goalWeight"] as? Double,
            let activityLevel = record["activityLevel"] as? String,
            let usesGLP1 = record["usesGLP1"] as? Int,
            let dietaryPreferences = record["dietaryPreferences"] as? String,
            let coachType = record["coachType"] as? String,
            let accountType = record["accountType"] as? String
        else { return nil }

        self.id = UUID(uuidString: record.recordID.recordName) ?? UUID()
        self.name = name
        self.age = age
        self.gender = gender
        self.height = height
        self.startingWeight = startingWeight
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        self.bodyFatPercentage = record["bodyFatPercentage"] as? Double
        self.activityLevel = activityLevel
        self.usesGLP1 = usesGLP1 == 1
        self.dietaryPreferences = dietaryPreferences
        self.coachType = coachType
        self.accountType = accountType
    }

    func toRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record["name"] = name as CKRecordValue
        record["age"] = age as CKRecordValue
        record["gender"] = gender as CKRecordValue
        record["height"] = height as CKRecordValue
        record["startingWeight"] = startingWeight as CKRecordValue
        record["currentWeight"] = currentWeight as CKRecordValue
        record["goalWeight"] = goalWeight as CKRecordValue
        if let bodyFat = bodyFatPercentage {
            record["bodyFatPercentage"] = bodyFat as CKRecordValue
        }
        record["activityLevel"] = activityLevel as CKRecordValue
        record["usesGLP1"] = (usesGLP1 ? 1 : 0) as CKRecordValue
        record["dietaryPreferences"] = dietaryPreferences as CKRecordValue
        record["coachType"] = coachType as CKRecordValue
        record["accountType"] = accountType as CKRecordValue
        return record
    }
}
