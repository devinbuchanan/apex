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
            profile = nil
        }
    }
}
