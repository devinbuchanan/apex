import Foundation
import HealthKit
import Combine

class HealthKitService: ObservableObject {
    static let shared = HealthKitService()

    private let store = HKHealthStore()
    private var queries: [HKObserverQuery] = []

    @Published var stepsToday: Double = 0
    @Published var workouts: [HKWorkout] = []
    @Published var sleep: [HKCategorySample] = []
    @Published var hydration: Double = 0
    @Published var isAuthorized: Bool = false

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        var readTypes = Set<HKObjectType>()
        if let steps = HKObjectType.quantityType(forIdentifier: .stepCount) {
            readTypes.insert(steps)
        }
        if let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            readTypes.insert(sleep)
        }
        if let water = HKObjectType.quantityType(forIdentifier: .dietaryWater) {
            readTypes.insert(water)
        }
        readTypes.insert(HKObjectType.workoutType())

        store.requestAuthorization(toShare: nil, read: readTypes) { success, _ in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.startObservers()
                    self.fetchAll()
                }
            }
        }
    }

    func fetchAll() {
        fetchSteps()
        fetchWorkouts()
        fetchSleep()
        fetchHydration()
    }

    private func startObservers() {
        queries.forEach { store.stop($0) }
        queries.removeAll()

        if let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount) {
            let query = HKObserverQuery(sampleType: stepsType, predicate: nil) { [weak self] _, completion, _ in
                self?.fetchSteps()
                completion()
            }
            store.execute(query)
            queries.append(query)
        }
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let query = HKObserverQuery(sampleType: sleepType, predicate: nil) { [weak self] _, completion, _ in
                self?.fetchSleep()
                completion()
            }
            store.execute(query)
            queries.append(query)
        }
        if let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) {
            let query = HKObserverQuery(sampleType: waterType, predicate: nil) { [weak self] _, completion, _ in
                self?.fetchHydration()
                completion()
            }
            store.execute(query)
            queries.append(query)
        }
        let workoutType = HKObjectType.workoutType()
        let workoutQuery = HKObserverQuery(sampleType: workoutType, predicate: nil) { [weak self] _, completion, _ in
            self?.fetchWorkouts()
            completion()
        }
        store.execute(workoutQuery)
        queries.append(workoutQuery)
    }

    private func fetchSteps() {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            DispatchQueue.main.async {
                self?.stepsToday = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            }
        }
        store.execute(query)
    }

    private func fetchWorkouts() {
        let type = HKObjectType.workoutType()
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, _ in
            DispatchQueue.main.async {
                self?.workouts = results as? [HKWorkout] ?? []
            }
        }
        store.execute(query)
    }

    private func fetchSleep() {
        guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, _ in
            DispatchQueue.main.async {
                self?.sleep = results as? [HKCategorySample] ?? []
            }
        }
        store.execute(query)
    }

    private func fetchHydration() {
        guard let type = HKObjectType.quantityType(forIdentifier: .dietaryWater) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            DispatchQueue.main.async {
                self?.hydration = result?.sumQuantity()?.doubleValue(for: .liter()) ?? 0
            }
        }
        store.execute(query)
    }
}
