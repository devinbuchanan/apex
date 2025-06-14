import SwiftUI
import Combine
import CoreData

class OnboardingCoordinator: ObservableObject {
    enum Step: Int, CaseIterable {
        case age, gender, height, weight, goal, activity, dietaryPrefs, glp1, coachPersonality, healthKit
    }

    @Published var step: Step
    @Published var age: String = ""
    @Published var gender: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var goal: String = ""
    @Published var activityLevel: String = ""
    @Published var dietaryPrefs: String = ""
    @Published var usesGLP1: Bool = false
    @Published var coachPersonality: String = ""
    @Published var enableHealthKit: Bool = false
    @Published var error: String?

    @AppStorage("onboardingStep") private var savedStep: Int = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompleted: Bool = false

    private let stack: CoreDataStack

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        step = Step(rawValue: savedStep) ?? .age
    }

    func next() {
        guard validateCurrentStep() else { return }
        if step == .healthKit {
            completeOnboarding()
            return
        }
        step = Step(rawValue: step.rawValue + 1) ?? .age
        savedStep = step.rawValue
        error = nil
    }

    func back() {
        guard step.rawValue > 0 else { return }
        step = Step(rawValue: step.rawValue - 1) ?? .age
        savedStep = step.rawValue
        error = nil
    }

    private func validateCurrentStep() -> Bool {
        switch step {
        case .age:
            guard Int(age) != nil else { error = "Enter a valid age"; return false }
        case .gender:
            guard !gender.isEmpty else { error = "Select a gender"; return false }
        case .height:
            guard Double(height) != nil else { error = "Enter height"; return false }
        case .weight:
            guard Double(weight) != nil else { error = "Enter weight"; return false }
        case .goal:
            guard !goal.isEmpty else { error = "Enter a goal"; return false }
        case .activity:
            guard !activityLevel.isEmpty else { error = "Enter activity level"; return false }
        case .dietaryPrefs:
            guard !dietaryPrefs.isEmpty else { error = "Enter dietary preference"; return false }
        case .glp1:
            break
        case .coachPersonality:
            guard !coachPersonality.isEmpty else { error = "Choose a coach style"; return false }
        case .healthKit:
            guard enableHealthKit else { error = "Enable HealthKit to proceed"; return false }
        }
        return true
    }

    private func completeOnboarding() {
        let context = stack.context
        let profile = UserProfile(context: context)
        profile.id = UUID()
        profile.name = "User"
        profile.age = Int16(Int(age) ?? 0)
        let wt = Double(weight) ?? 0
        profile.currentWeight = wt
        profile.startingWeight = wt
        profile.goalWeight = wt
        profile.bodyFatPercentage = 0
        profile.height = Double(height) ?? 0
        profile.joinDate = Date()
        profile.gender = gender
        profile.goal = goal
        profile.activityLevel = activityLevel
        profile.dietaryPreferences = dietaryPrefs
        profile.usesGLP1 = usesGLP1
        profile.coachPersonality = coachPersonality
        profile.hasCompletedOnboarding = true
        profile.onboardingStep = Int16(Step.healthKit.rawValue)
        profile.accountType = "guest"
        profile.syncHealthKit = enableHealthKit
        do {
            try stack.saveContext()
            hasCompleted = true
            savedStep = 0
        } catch {
            self.error = "Failed to save profile"
        }
    }
}
