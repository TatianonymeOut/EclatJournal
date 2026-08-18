import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Aujourd’hui", systemImage: "sparkles")
                }

            JournalListView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }

            TimelineView()
                .tabItem {
                    Label("Calendrier", systemImage: "calendar")
                }

            HealthLogView()
                .tabItem {
                    Label("Santé", systemImage: "heart.text.square")
                }

            InsightsView()
                .tabItem {
                    Label("Tendances", systemImage: "chart.xyaxis.line")
                }

            SettingsView()
                .tabItem {
                    Label("Réglages", systemImage: "gearshape")
                }
        }
        #if os(macOS)
        .frame(minWidth: 840, minHeight: 600)
        #endif
    }
}
