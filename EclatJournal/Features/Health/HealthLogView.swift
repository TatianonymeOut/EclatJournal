import SwiftData
import SwiftUI

struct HealthLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HealthEvent.date, order: .reverse) private var events: [HealthEvent]
    @State private var isPresentingEditor = false
    @State private var deletionErrorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if events.isEmpty {
                    EmptyState(
                        title: "Aucun élément de santé",
                        symbol: "heart.text.square",
                        description: "Tu peux garder une trace d’un symptôme, d’une prise de médicament et de ton ressenti."
                    ) {
                        isPresentingEditor = true
                    }
                } else {
                    List {
                        Section {
                            Label(
                                "Ces notes sont personnelles et ne remplacent pas un avis médical.",
                                systemImage: "info.circle"
                            )
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }

                        ForEach(events) { event in
                            HealthEventCard(event: event)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                    #if os(iOS)
                    .listStyle(.insetGrouped)
                    #else
                    .listStyle(.inset)
                    #endif
                }
            }
            .navigationTitle("Santé")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingEditor = true
                    } label: {
                        Label("Ajouter", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingEditor) {
            QuickHealthEventEditor()
        }
        .alert("Impossible de supprimer cette note", isPresented: Binding(
            get: { deletionErrorMessage != nil },
            set: { if !$0 { deletionErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { deletionErrorMessage = nil }
        } message: {
            Text(deletionErrorMessage ?? "Réessaie dans un instant.")
        }
    }

    private func delete(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { events[$0] }
        var parentEntries: [UUID: JournalEntry] = [:]

        for event in eventsToDelete {
            if let entry = event.entry {
                entry.healthEvents.removeAll { $0.id == event.id }
                parentEntries[entry.id] = entry
            }
            modelContext.delete(event)
        }

        for entry in parentEntries.values where !entry.hasMeaningfulContent {
            modelContext.delete(entry)
        }

        do {
            try modelContext.save()
        } catch {
            deletionErrorMessage = error.localizedDescription
        }
    }
}

private struct QuickHealthEventEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var draft = HealthEventDraft()

    var body: some View {
        NavigationStack {
            Form {
                Section("Ajouter à ton journal") {
                    HealthDraftEditor(draft: $draft) {}
                }
                Section {
                    Text("Un élément de santé est enregistré dans une entrée de journal, pour conserver le contexte sans produire d’analyse médicale.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Note de santé")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        save()
                    }
                    .disabled(draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let entry = JournalEntry(
            createdAt: draft.date,
            mood: .neutral,
            moodIntensity: 3
        )
        let event = HealthEvent(
            id: draft.id,
            date: draft.date,
            kind: draft.kind,
            title: draft.title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: draft.note.trimmingCharacters(in: .whitespacesAndNewlines),
            dosage: draft.dosage.trimmingCharacters(in: .whitespacesAndNewlines),
            intensity: draft.kind == .symptom ? draft.intensity : 0,
            entry: entry
        )
        entry.healthEvents.append(event)
        modelContext.insert(entry)
        modelContext.insert(event)
        try? modelContext.save()
        dismiss()
    }
}
