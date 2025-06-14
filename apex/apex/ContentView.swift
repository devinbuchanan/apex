//
//  ContentView.swift
//  apex
//
//  Created by Devin Buchanan on 6/13/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: []) private var profiles: FetchedResults<UserProfile>

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(profiles) { profile in
                    NavigationLink {
                        Text(profile.name)
                    } label: {
                        Text(profile.name)
                    }
                }
                .onDelete(perform: deleteProfiles)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addProfile) {
                        Label("Add Profile", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addProfile() {
        withAnimation {
            let profile = UserProfile(context: moc)
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
            try? moc.save()
        }
    }

    private func deleteProfiles(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let profile = profiles[index]
                moc.delete(profile)
            }
            try? moc.save()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
