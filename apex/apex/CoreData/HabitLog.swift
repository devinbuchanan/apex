import Foundation
import CoreData

@objc(HabitLog)
public class HabitLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var habitName: String?
    @NSManaged public var completed: Bool
    @NSManaged public var user: UserProfile?
}

extension HabitLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitLog> {
        return NSFetchRequest<HabitLog>(entityName: "HabitLog")
    }
}
