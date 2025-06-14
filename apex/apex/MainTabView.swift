import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .accessibilityLabel("Home tab")

            Text("Log")
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Log")
                }
                .accessibilityLabel("Log tab")

            Text("Progress")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
                .accessibilityLabel("Progress tab")

            Text("Coach")
                .tabItem {
                    Image(systemName: "message")
                    Text("Coach")
                }
                .accessibilityLabel("Coach tab")

            Text("Profile")
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .accessibilityLabel("Profile tab")
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
