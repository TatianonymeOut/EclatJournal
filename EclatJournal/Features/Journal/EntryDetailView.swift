import SwiftUI

struct EntryDetailView: View {
    let entry: JournalEntry
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.createdAt.eclatDayTitle.capitalized)
                            .font(.title2.bold())
                        Text(entry.createdAt.eclatShortTime)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    MoodBadge(mood: entry.mood, intensity: entry.moodIntensity)
                }

                if !entry.note.isEmpty {
                    SectionCard {
                        Text(entry.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                }

                if !entry.attachments.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Souvenirs", systemImage: "photo.stack")
                            .font(.headline)
                        ForEach(entry.attachments) { attachment in
                            MediaAttachmentView(
                                kind: attachment.kind,
                                fileURL: MediaStore.fileURL(for: attachment.filename),
                                caption: attachment.caption
                            )
                        }
                    }
                }

                if !entry.healthEvents.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Santé et médicaments", systemImage: "heart.text.square")
                            .font(.headline)
                        ForEach(entry.healthEvents) { event in
                            HealthEventCard(event: event)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: 760, alignment: .leading)
        }
        .navigationTitle("Entrée")
        .toolbar {
            Button("Modifier") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            EntryEditorView(entry: entry)
        }
    }
}

struct HealthEventCard: View {
    let event: HealthEvent

    var body: some View {
        SectionCard {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: event.kind.symbolName)
                    .font(.title3)
                    .foregroundStyle(event.kind == .symptom ? .orange : .indigo)
                    .frame(width: 26)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(event.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(event.date.eclatShortTime)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if event.kind == .symptom, event.intensity > 0 {
                        Text("Intensité \(event.intensity)/5")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if event.kind == .medication, !event.dosage.isEmpty {
                        Text(event.dosage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !event.note.isEmpty {
                        Text(event.note)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}
