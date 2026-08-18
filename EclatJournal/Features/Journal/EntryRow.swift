import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry

    var body: some View {
        SectionCard {
            HStack(alignment: .top, spacing: 12) {
                Text(entry.mood.emoji)
                    .font(.largeTitle)
                    .frame(width: 42)

                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        MoodBadge(mood: entry.mood, intensity: entry.moodIntensity)
                        Spacer(minLength: 4)
                        Text(entry.createdAt.eclatShortTime)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.primary)
                    }

                    if !entry.attachments.isEmpty || !entry.healthEvents.isEmpty {
                        HStack(spacing: 10) {
                            if !entry.attachments.isEmpty {
                                Label("\(entry.attachments.count)", systemImage: "paperclip")
                            }
                            if !entry.healthEvents.isEmpty {
                                Label("\(entry.healthEvents.count)", systemImage: "heart.text.square")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
