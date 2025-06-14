import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private lazy var model: NSManagedObjectModel = {
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
            attribute(name: "weight", type: .doubleAttributeType),
            attribute(name: "height", type: .doubleAttributeType),
            attribute(name: "joinDate", type: .dateAttributeType)
        ]

        let food = NSEntityDescription()
        food.name = "FoodLog"
        food.managedObjectClassName = NSStringFromClass(FoodLog.self)
        food.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "items", type: .stringAttributeType, optional: true),
            attribute(name: "calories", type: .doubleAttributeType)
        ]

        let workout = NSEntityDescription()
        workout.name = "WorkoutLog"
        workout.managedObjectClassName = NSStringFromClass(WorkoutLog.self)
        workout.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "type", type: .stringAttributeType, optional: true),
            attribute(name: "duration", type: .doubleAttributeType)
        ]

        let habit = NSEntityDescription()
        habit.name = "HabitLog"
        habit.managedObjectClassName = NSStringFromClass(HabitLog.self)
        habit.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "date", type: .dateAttributeType),
            attribute(name: "habitName", type: .stringAttributeType, optional: true),
            attribute(name: "completed", type: .booleanAttributeType)
        ]

        let award = NSEntityDescription()
        award.name = "Award"
        award.managedObjectClassName = NSStringFromClass(Award.self)
        award.properties = [
            attribute(name: "id", type: .UUIDAttributeType),
            attribute(name: "name", type: .stringAttributeType),
            attribute(name: "dateAwarded", type: .dateAttributeType)
        ]

        model.entities = [user, food, workout, habit, award]
        return model
    }()

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "ApexModel", managedObjectModel: model)
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No persistent store description")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.devinbuchanan.apex")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
