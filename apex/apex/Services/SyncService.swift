import Foundation
import CloudKit

@MainActor
class SyncService: ObservableObject {
    static let shared = SyncService()
    private init() {}

    @Published var cloudKitLastSync: Date?
    @Published var cloudKitError: String?

    @Published var healthKitLastSync: Date?

    func syncNow() {
        syncCloudKit()
        syncHealthKit()
    }

    func syncCloudKit() {
        cloudKitError = nil
        let container = CKContainer.default()
        print("Starting CloudKit sync")
        container.privateCloudDatabase.fetchAllRecordZones { [weak self] _, error in
            Task { @MainActor in
                if let error = error {
                    self?.cloudKitError = "Sync failed: Check connection or try again"
                    print("CloudKit sync failed: \(error.localizedDescription)")
                } else {
                    self?.cloudKitLastSync = Date()
                    print("CloudKit sync succeeded at \(self?.cloudKitLastSync ?? Date())")
                }
            }
        }
    }

    func syncHealthKit() {
        if HealthKitService.shared.isAuthorized {
            print("Starting HealthKit sync")
            HealthKitService.shared.fetchAll()
            healthKitLastSync = Date()
            print("HealthKit sync succeeded at \(healthKitLastSync ?? Date())")
        }
    }
}
