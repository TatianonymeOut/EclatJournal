import Foundation
import SwiftData

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var moodRawValue: String
    var moodIntensity: Int
    var note: String
    @Relationship(deleteRule: .cascade, inverse: \MediaAttachment.entry)
    var attachments: [MediaAttachment]
    @Relationship(deleteRule: .cascade, inverse: \HealthEvent.entry)
    var healthEvents: [HealthEvent]

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        mood: Mood = .neutral,
        moodIntensity: Int = 3,
        note: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        moodRawValue = mood.rawValue
        self.moodIntensity = moodIntensity
        self.note = note
        attachments = []
        healthEvents = []
    }

    var mood: Mood {
        get { Mood(rawValue: moodRawValue) ?? .neutral }
        set { moodRawValue = newValue.rawValue }
    }

    var hasMeaningfulContent: Bool {
        !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !attachments.isEmpty ||
            !healthEvents.isEmpty
    }
}

@Model
final class MediaAttachment {
    @Attribute(.unique) var id: UUID
    var kindRawValue: String
    var filename: String
    var caption: String
    var createdAt: Date
    var duration: Double
    var entry: JournalEntry?

    init(
        id: UUID = UUID(),
        kind: AttachmentKind,
        filename: String,
        caption: String = "",
        createdAt: Date = .now,
        duration: Double = 0,
        entry: JournalEntry? = nil
    ) {
        self.id = id
        kindRawValue = kind.rawValue
        self.filename = filename
        self.caption = caption
        self.createdAt = createdAt
        self.duration = duration
        self.entry = entry
    }

    var kind: AttachmentKind {
        get { AttachmentKind(rawValue: kindRawValue) ?? .photo }
        set { kindRawValue = newValue.rawValue }
    }
}

@Model
final class HealthEvent {
    @Attribute(.unique) var id: UUID
    var date: Date
    var kindRawValue: String
    var title: String
    var note: String
    var dosage: String
    var intensity: Int
    var entry: JournalEntry?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        kind: HealthEventKind,
        title: String,
        note: String = "",
        dosage: String = "",
        intensity: Int = 0,
        entry: JournalEntry? = nil
    ) {
        self.id = id
        self.date = date
        kindRawValue = kind.rawValue
        self.title = title
        self.note = note
        self.dosage = dosage
        self.intensity = intensity
        self.entry = entry
    }

    var kind: HealthEventKind {
        get { HealthEventKind(rawValue: kindRawValue) ?? .symptom }
        set { kindRawValue = newValue.rawValue }
    }
}
