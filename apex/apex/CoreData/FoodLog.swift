import Foundation
import CoreData

@objc(FoodLog)
public class FoodLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var items: String?
    @NSManaged public var calories: Double
    @NSManaged public var user: UserProfile?
}

extension FoodLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodLog> {
        return NSFetchRequest<FoodLog>(entityName: "FoodLog")
    }
}
extension FoodLog: Identifiable {}
