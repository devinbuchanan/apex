import Foundation
import CoreData

@objc(Award)
public class Award: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var dateAwarded: Date
    @NSManaged public var user: UserProfile?
}

extension Award {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Award> {
        return NSFetchRequest<Award>(entityName: "Award")
    }
}
