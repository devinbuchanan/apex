import Foundation
import CoreData
import Combine

class HomeViewModel: ObservableObject {
    private let stack: CoreDataStack
    private var cancellables = Set<AnyCancellable>()

    @Published var profiles: [UserProfile] = []

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        fetchProfiles()
    }

    func fetchProfiles() {
        let request = UserProfile.fetchRequest()
        do {
            profiles = try stack.context.fetch(request)
        } catch {
            profiles = []
        }
    }

    func addProfile() {
        let context = stack.context
        let profile = UserProfile(context: context)
        profile.id = UUID()
        profile.name = "New User"
        profile.age = 0
        profile.currentWeight = 0
        profile.startingWeight = 0
        profile.goalWeight = 0
        profile.bodyFatPercentage = 0
        profile.height = 0
        profile.joinDate = Date()
        profile.accountType = "guest"
        profile.syncHealthKit = false
        save()
        fetchProfiles()
    }

    func delete(_ profiles: [UserProfile]) {
        let context = stack.context
        for profile in profiles {
            context.delete(profile)
        }
        save()
        fetchProfiles()
    }

    private func save() {
        do {
            try stack.saveContext()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
