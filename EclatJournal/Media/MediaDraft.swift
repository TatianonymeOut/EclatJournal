import Foundation
import UniformTypeIdentifiers

struct MediaAttachmentDraft: Identifiable, Equatable {
    let id: UUID
    let kind: AttachmentKind
    let filename: String
    var caption: String
    let duration: Double

    init(
        id: UUID = UUID(),
        kind: AttachmentKind,
        filename: String,
        caption: String = "",
        duration: Double = 0
    ) {
        self.id = id
        self.kind = kind
        self.filename = filename
        self.caption = caption
        self.duration = duration
    }

    init(attachment: MediaAttachment) {
        id = attachment.id
        kind = attachment.kind
        filename = attachment.filename
        caption = attachment.caption
        duration = attachment.duration
    }

    var fileURL: URL {
        MediaStore.fileURL(for: filename)
    }
}

struct HealthEventDraft: Identifiable, Equatable {
    let id: UUID
    var date: Date
    var kind: HealthEventKind
    var title: String
    var note: String
    var dosage: String
    var intensity: Int

    init(
        id: UUID = UUID(),
        date: Date = .now,
        kind: HealthEventKind = .symptom,
        title: String = "",
        note: String = "",
        dosage: String = "",
        intensity: Int = 0
    ) {
        self.id = id
        self.date = date
        self.kind = kind
        self.title = title
        self.note = note
        self.dosage = dosage
        self.intensity = intensity
    }

    init(event: HealthEvent) {
        id = event.id
        date = event.date
        kind = event.kind
        title = event.title
        note = event.note
        dosage = event.dosage
        intensity = event.intensity
    }
}
