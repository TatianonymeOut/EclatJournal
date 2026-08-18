import SwiftData
import SwiftUI

struct TimelineView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var selectedDay = Date.now
    @State private var isPresentingComposer = false

    private var dayEntries: [JournalEntry] {
        entries
            .filter { Calendar.current.isDate($0.createdAt, inSameDayAs: selectedDay) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DatePicker(
                        "Choisir une journée",
                        selection: $selectedDay,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)

                    HStack {
                        Text(selectedDay.eclatDayTitle.capitalized)
                            .font(.headline)
                        Spacer()
                        Text("\(dayEntries.count) moment\(dayEntries.count > 1 ? "s" : "")")
                            .foregroundStyle(.secondary)
                    }

                    if dayEntries.isEmpty {
                        EmptyState(
                            title: "Aucun moment noté",
                            symbol: "calendar.badge.plus",
                            description: "Tu peux ajouter une entrée pour ce jour."
                        ) {
                            isPresentingComposer = true
                        }
                        .frame(minHeight: 220)
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(dayEntries.enumerated()), id: \.element.id) { index, entry in
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(spacing: 0) {
                                        Circle()
                                            .fill(entry.mood.tint)
                                            .frame(width: 12, height: 12)
                                        if index < dayEntries.count - 1 {
                                            Rectangle()
                                                .fill(.quaternary)
                                                .frame(width: 2)
                                                .frame(minHeight: 90)
                                        }
                                    }

                                    NavigationLink {
                                        EntryDetailView(entry: entry)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 7) {
                                            Text(entry.createdAt.eclatShortTime)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            MoodBadge(mood: entry.mood, intensity: entry.moodIntensity)
                                            if !entry.note.isEmpty {
                                                Text(entry.note)
                                                    .lineLimit(3)
                                                    .foregroundStyle(.primary)
                                            }
                                        }
                                        .padding(.bottom, 20)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 760, alignment: .leading)
            }
            .navigationTitle("Calendrier")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingComposer = true
                    } label: {
                        Label("Ajouter", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingComposer) {
            EntryEditorView()
        }
    }
}
