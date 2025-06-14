import Foundation
import CoreData

@objc(WorkoutLog)
public class WorkoutLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var type: String?
    @NSManaged public var duration: Double
    @NSManaged public var user: UserProfile?
}

extension WorkoutLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutLog> {
        return NSFetchRequest<WorkoutLog>(entityName: "WorkoutLog")
    }
}
