import Foundation
import Combine

class CoachViewModel: ObservableObject {
    @Published var tips: [String] = []

    init() {
        loadTips()
    }

    func loadTips() {
        tips = ["Stay hydrated", "Keep a regular workout schedule"]
    }
}
