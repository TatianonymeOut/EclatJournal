import SwiftData
import SwiftUI

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private let entry: JournalEntry?
    private let existingFilenames: Set<String>
    @State private var createdAt: Date
    @State private var mood: Mood
    @State private var intensity: Int
    @State private var note: String
    @State private var attachments: [MediaAttachmentDraft]
    @State private var healthDrafts: [HealthEventDraft]
    @State private var discardedNewMediaFilenames: Set<String> = []
    @State private var saveErrorMessage: String?
    @State private var saved = false

    init(entry: JournalEntry? = nil, initialMood: Mood = .neutral) {
        self.entry = entry
        existingFilenames = Set(entry?.attachments.map(\.filename) ?? [])
        _createdAt = State(initialValue: entry?.createdAt ?? .now)
        _mood = State(initialValue: entry?.mood ?? initialMood)
        _intensity = State(initialValue: entry?.moodIntensity ?? 3)
        _note = State(initialValue: entry?.note ?? "")
        _attachments = State(initialValue: entry?.attachments.map(MediaAttachmentDraft.init) ?? [])
        _healthDrafts = State(initialValue: entry?.healthEvents.map(HealthEventDraft.init) ?? [])
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ce moment") {
                    DatePicker("Date et heure", selection: $createdAt)

                    Picker("Humeur", selection: $mood) {
                        ForEach(Mood.allCases) { mood in
                            Text("\(mood.emoji) \(mood.label)").tag(mood)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Intensité")
                            Spacer()
                            Text("\(intensity)/5")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: Binding(
                            get: { Double(intensity) },
                            set: { intensity = Int($0.rounded()) }
                        ), in: 1 ... 5, step: 1)
                        .tint(mood.tint)
                    }
                }

                Section("Contexte") {
                    TextEditor(text: $note)
                        .frame(minHeight: 130)
                        .accessibilityLabel("Écrire ce qui s’est passé")
                }

                Section("Souvenirs") {
                    MediaComposer(drafts: $attachments) { draft in
                        guard !existingFilenames.contains(draft.filename) else { return }
                        discardedNewMediaFilenames.insert(draft.filename)
                    }
                }

                Section {
                    HealthDraftList(drafts: $healthDrafts)
                } header: {
                    Text("Santé et médicaments")
                } footer: {
                    Text("Éclat est un carnet personnel. Il ne fournit ni diagnostic ni conseil médical.")
                }
            }
            .navigationTitle(entry == nil ? "Nouvelle entrée" : "Modifier l’entrée")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        cleanUpUncommittedMedia()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(!hasContent)
                }
            }
        }
        .interactiveDismissDisabled(
            !saved && (
                attachments.contains { !existingFilenames.contains($0.filename) } ||
                    !discardedNewMediaFilenames.isEmpty
            )
        )
        .alert("Impossible d’enregistrer l’entrée", isPresented: Binding(
            get: { saveErrorMessage != nil },
            set: { if !$0 { saveErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { saveErrorMessage = nil }
        } message: {
            Text(saveErrorMessage ?? "Réessaie dans un instant.")
        }
    }

    private var hasContent: Bool {
        !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !attachments.isEmpty ||
            healthDrafts.contains { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    private func save() {
        let target = entry ?? JournalEntry(
            createdAt: createdAt,
            mood: mood,
            moodIntensity: intensity,
            note: note
        )
        if entry == nil {
            modelContext.insert(target)
        }

        target.createdAt = createdAt
        target.mood = mood
        target.moodIntensity = intensity
        target.note = note.trimmingCharacters(in: .whitespacesAndNewlines)

        let oldFilenames = Set(target.attachments.map(\.filename))
        let retainedFilenames = Set(attachments.map(\.filename))
        let filenamesToRemoveAfterSave = oldFilenames
            .subtracting(retainedFilenames)
            .union(discardedNewMediaFilenames)

        let oldAttachments = target.attachments
        let oldEvents = target.healthEvents
        for oldAttachment in oldAttachments {
            modelContext.delete(oldAttachment)
        }
        for oldEvent in oldEvents {
            modelContext.delete(oldEvent)
        }
        target.attachments.removeAll()
        target.healthEvents.removeAll()

        for draft in attachments {
            let attachment = MediaAttachment(
                kind: draft.kind,
                filename: draft.filename,
                caption: draft.caption,
                duration: draft.duration,
                entry: target
            )
            modelContext.insert(attachment)
            target.attachments.append(attachment)
        }

        for draft in healthDrafts where !draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let event = HealthEvent(
                date: draft.date,
                kind: draft.kind,
                title: draft.title.trimmingCharacters(in: .whitespacesAndNewlines),
                note: draft.note.trimmingCharacters(in: .whitespacesAndNewlines),
                dosage: draft.dosage.trimmingCharacters(in: .whitespacesAndNewlines),
                intensity: draft.kind == .symptom ? draft.intensity : 0,
                entry: target
            )
            modelContext.insert(event)
            target.healthEvents.append(event)
        }

        do {
            try modelContext.save()
            for filename in filenamesToRemoveAfterSave {
                MediaStore.remove(filename: filename)
            }
            discardedNewMediaFilenames.removeAll()
            saved = true
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func cleanUpUncommittedMedia() {
        let currentNewFilenames = Set(
            attachments
                .filter { !existingFilenames.contains($0.filename) }
                .map(\.filename)
        )
        for filename in currentNewFilenames.union(discardedNewMediaFilenames) {
            MediaStore.remove(filename: filename)
        }
    }
}

private struct HealthDraftList: View {
    @Binding var drafts: [HealthEventDraft]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if drafts.isEmpty {
                Text("Ajoute un symptôme ou la prise d’un médicament si tu veux garder ce contexte.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }

            ForEach(drafts.indices, id: \.self) { index in
                HealthDraftEditor(draft: $drafts[index]) {
                    drafts.remove(at: index)
                }
            }

            Menu {
                Button {
                    drafts.append(HealthEventDraft(kind: .symptom))
                } label: {
                    Label("Symptôme", systemImage: "waveform.path.ecg")
                }
                Button {
                    drafts.append(HealthEventDraft(kind: .medication))
                } label: {
                    Label("Médicament", systemImage: "pills")
                }
            } label: {
                Label("Ajouter un élément", systemImage: "plus.circle")
            }
        }
    }
}

struct HealthDraftEditor: View {
    @Binding var draft: HealthEventDraft
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Picker("Type", selection: $draft.kind) {
                    ForEach(HealthEventKind.allCases) { kind in
                        Label(kind.label, systemImage: kind.symbolName).tag(kind)
                    }
                }
                .pickerStyle(.menu)

                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("Supprimer cet élément de santé")
            }

            TextField(
                draft.kind == .symptom ? "Ex. migraine, fatigue…" : "Ex. paracétamol, vitamine D…",
                text: $draft.title
            )
            .textFieldStyle(.roundedBorder)

            if draft.kind == .medication {
                TextField("Dosage ou quantité (facultatif)", text: $draft.dosage)
                    .textFieldStyle(.roundedBorder)
            } else {
                HStack {
                    Text("Intensité")
                    Slider(value: Binding(
                        get: { Double(draft.intensity) },
                        set: { draft.intensity = Int($0.rounded()) }
                    ), in: 0 ... 5, step: 1)
                    Text(draft.intensity == 0 ? "—" : "\(draft.intensity)/5")
                        .foregroundStyle(.secondary)
                        .frame(width: 38, alignment: .trailing)
                }
            }

            DatePicker("Quand ?", selection: $draft.date)

            TextField("Ressenti ou contexte (facultatif)", text: $draft.note, axis: .vertical)
                .lineLimit(2 ... 5)
                .textFieldStyle(.roundedBorder)
        }
        .padding(12)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
