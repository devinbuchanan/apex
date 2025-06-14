import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(viewModel.profiles, id: \.id) { profile in
                    NavigationLink {
                        Text(profile.name)
                    } label: {
                        Text(profile.name)
                    }
                }
                .onDelete { indexSet in
                    let items = indexSet.map { viewModel.profiles[$0] }
                    viewModel.delete(items)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: viewModel.addProfile) {
                        Label("Add Profile", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
