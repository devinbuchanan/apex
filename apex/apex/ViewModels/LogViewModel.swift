import Foundation
import Combine
import CoreData

class LogViewModel: ObservableObject {
    private let stack: CoreDataStack

    @Published var logs: [FoodLog] = []

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        fetchLogs()
    }

    func fetchLogs() {
        let request = FoodLog.fetchRequest()
        do {
            logs = try stack.context.fetch(request)
        } catch {
            print("Failed to fetch logs: \(error.localizedDescription)")
            logs = []
        }
    }
}
