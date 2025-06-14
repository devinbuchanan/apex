import Foundation
import Combine
import CoreData

class ProgressViewModel: ObservableObject {
    private let stack: CoreDataStack

    @Published var awards: [Award] = []

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        fetchAwards()
    }

    func fetchAwards() {
        let request = Award.fetchRequest()
        do {
            awards = try stack.context.fetch(request)
        } catch {
            awards = []
        }
    }
}
