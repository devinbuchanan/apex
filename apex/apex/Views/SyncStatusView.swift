import SwiftUI

struct SyncStatusView: View {
    @EnvironmentObject var sync: SyncService

    private var cloudKitStatusText: String {
        if let error = sync.cloudKitError {
            return error
        }
        if let date = sync.cloudKitLastSync {
            return "Last synced \(date.formatted())"
        }
        return "Never synced"
    }

    private var healthKitStatusText: String {
        if !HealthKitService.shared.isAuthorized {
            return "Off"
        }
        if let date = sync.healthKitLastSync {
            return "Last synced \(date.formatted())"
        }
        return "On"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("CloudKit", systemImage: "icloud")
                Spacer()
                Text(cloudKitStatusText)
                    .foregroundStyle(sync.cloudKitError == nil ? .primary : .red)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Label("HealthKit", systemImage: "heart.fill")
                Spacer()
                Text(healthKitStatusText)
                    .multilineTextAlignment(.trailing)
            }
            Button("Sync Now") {
                sync.syncNow()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SyncStatusView()
        .environmentObject(SyncService.shared)
}
