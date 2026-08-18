import SwiftData
import SwiftUI

@main
struct EclatJournalApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                JournalEntry.self,
                MediaAttachment.self,
                HealthEvent.self
            ])
            let configuration = ModelConfiguration(schema: schema)
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Impossible de préparer le journal local : \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)

        #if os(macOS)
        Settings {
            SettingsView()
                .modelContainer(modelContainer)
        }
        #endif
    }
}
