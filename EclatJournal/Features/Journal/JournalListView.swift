import SwiftData
import SwiftUI

struct JournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var isPresentingComposer = false
    @State private var searchText = ""
    @State private var deletionErrorMessage: String?

    private var filteredEntries: [JournalEntry] {
        guard !searchText.isEmpty else { return entries }
        return entries.filter {
            $0.note.localizedCaseInsensitiveContains(searchText) ||
                $0.healthEvents.contains {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                        $0.note.localizedCaseInsensitiveContains(searchText)
                }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredEntries.isEmpty {
                    EmptyState(
                        title: searchText.isEmpty ? "Ton journal est prêt" : "Aucun résultat",
                        symbol: searchText.isEmpty ? "book.closed" : "magnifyingglass",
                        description: searchText.isEmpty
                            ? "Écris une première entrée pour commencer à observer tes journées."
                            : "Essaie un autre mot-clé."
                    ) {
                        isPresentingComposer = true
                    }
                } else {
                    List {
                        ForEach(groupedEntries, id: \.date) { group in
                            Section(group.date.formatted(.dateTime.day().month(.wide).year())) {
                                ForEach(group.entries) { entry in
                                    NavigationLink {
                                        EntryDetailView(entry: entry)
                                    } label: {
                                        EntryRow(entry: entry)
                                            .padding(.vertical, 4)
                                    }
                                }
                                .onDelete { offsets in
                                    delete(group.entries, at: offsets)
                                }
                            }
                        }
                    }
                    #if os(iOS)
                    .listStyle(.insetGrouped)
                    #else
                    .listStyle(.inset)
                    #endif
                }
            }
            .navigationTitle("Journal")
            .searchable(text: $searchText, prompt: "Rechercher dans le journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingComposer = true
                    } label: {
                        Label("Nouvelle entrée", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingComposer) {
            EntryEditorView()
        }
        .alert("Impossible de supprimer l’entrée", isPresented: Binding(
            get: { deletionErrorMessage != nil },
            set: { if !$0 { deletionErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { deletionErrorMessage = nil }
        } message: {
            Text(deletionErrorMessage ?? "Réessaie dans un instant.")
        }
    }

    private var groupedEntries: [(date: Date, entries: [JournalEntry])] {
        let calendar = Calendar.current
        let groups = Dictionary(grouping: filteredEntries) { calendar.startOfDay(for: $0.createdAt) }
        return groups
            .map { (date: $0.key, entries: $0.value.sorted { $0.createdAt > $1.createdAt }) }
            .sorted { $0.date > $1.date }
    }

    private func delete(_ source: [JournalEntry], at offsets: IndexSet) {
        let entriesToDelete = offsets.map { source[$0] }
        let filenamesToRemove = Set(entriesToDelete.flatMap { $0.attachments.map(\.filename) })

        for entry in entriesToDelete {
            modelContext.delete(entry)
        }

        do {
            try modelContext.save()
            for filename in filenamesToRemove {
                MediaStore.remove(filename: filename)
            }
        } catch {
            deletionErrorMessage = error.localizedDescription
        }
    }
}
