import Foundation

struct MoodCount: Identifiable {
    let mood: Mood
    let count: Int

    var id: String { mood.id }
}

struct MoodDay: Identifiable {
    let date: Date
    let averageIntensity: Double
    let mood: Mood

    var id: Date { date }
}

enum JournalInsights {
    static func moodCounts(for entries: [JournalEntry]) -> [MoodCount] {
        let counts = Dictionary(grouping: entries, by: \.mood).mapValues(\.count)
        return Mood.allCases.map { MoodCount(mood: $0, count: counts[$0, default: 0]) }
    }

    static func activeDays(for entries: [JournalEntry], calendar: Calendar = .autoupdatingCurrent) -> Int {
        Set(entries.map { calendar.startOfDay(for: $0.createdAt) }).count
    }

    static func moodDays(for entries: [JournalEntry], calendar: Calendar = .autoupdatingCurrent) -> [MoodDay] {
        let groups = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.createdAt) }
        return groups.map { date, entries in
            let average = entries.map(\.moodIntensity).reduce(0, +) / max(entries.count, 1)
            let dominantMood = Dictionary(grouping: entries, by: \.mood)
                .max { $0.value.count < $1.value.count }?
                .key ?? .neutral
            return MoodDay(date: date, averageIntensity: Double(average), mood: dominantMood)
        }
        .sorted { $0.date < $1.date }
    }
}
