import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var selectedMood: Mood?
    @State private var isPresentingEntryComposer = false

    private var todayEntries: [JournalEntry] {
        entries.filter { Calendar.current.isDateInToday($0.createdAt) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    SectionCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Réflexion du jour", systemImage: "quote.opening")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("« \(MantraCatalog.mantra(for: .now).text) »")
                                .font(.title3.weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Comment te sens-tu maintenant ?")
                            .font(.headline)

                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 76), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(Mood.allCases) { mood in
                                Button {
                                    selectedMood = mood
                                } label: {
                                    VStack(spacing: 4) {
                                        Text(mood.emoji)
                                            .font(.title2)
                                        Text(mood.label)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                }
                                .buttonStyle(.bordered)
                                .tint(mood.tint)
                                .accessibilityLabel("Créer une entrée : \(mood.label)")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Aujourd’hui")
                                .font(.headline)
                            Spacer()
                            Text("\(todayEntries.count) entrée\(todayEntries.count > 1 ? "s" : "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if todayEntries.isEmpty {
                            SectionCard {
                                HStack(spacing: 14) {
                                    Image(systemName: "sun.max")
                                        .font(.title2)
                                        .foregroundStyle(.orange)
                                    Text("Garde une trace d’un petit moment, d’une pensée ou de ton ressenti.")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } else {
                            ForEach(todayEntries) { entry in
                                NavigationLink {
                                    EntryDetailView(entry: entry)
                                } label: {
                                    EntryRow(entry: entry)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 760, alignment: .leading)
            }
            .navigationTitle("Bonjour")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingEntryComposer = true
                    } label: {
                        Label("Nouvelle entrée", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(item: $selectedMood) { mood in
            EntryEditorView(initialMood: mood)
        }
        .sheet(isPresented: $isPresentingEntryComposer) {
            EntryEditorView()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date.now.eclatDayTitle.capitalized)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Un instant pour toi")
                .font(.largeTitle.bold())
        }
    }
}
