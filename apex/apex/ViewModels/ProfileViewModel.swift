import Foundation
import Combine
import CoreData

class ProfileViewModel: ObservableObject {
    private let stack: CoreDataStack

    @Published var profile: UserProfile?

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        fetchProfile()
    }

    func fetchProfile() {
        let request = UserProfile.fetchRequest()
        request.fetchLimit = 1
        do {
            profile = try stack.context.fetch(request).first
        } catch {
            print("Failed to fetch profile: \(error.localizedDescription)")
            profile = nil
        }
    }

    func updateProfile(with model: UserProfileModel) {
        guard let profile = profile else { return }
        profile.update(from: model)
        do {
            try stack.saveContext()
            fetchProfile()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}
