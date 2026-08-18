import Foundation
import SwiftData

enum SampleData {
    static func insertIfNeeded(into context: ModelContext) {
        let descriptor = FetchDescriptor<JournalEntry>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }

        let calendar = Calendar.current
        let today = Date.now
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today) ?? today

        let first = JournalEntry(
            createdAt: today,
            mood: .calm,
            moodIntensity: 4,
            note: "J’ai pris un café au soleil avant de commencer ma journée. Ce petit moment calme m’a fait du bien."
        )
        let symptom = HealthEvent(
            date: today,
            kind: .symptom,
            title: "Maux de tête",
            note: "Légers, apparus en fin de matinée.",
            intensity: 2,
            entry: first
        )
        first.healthEvents.append(symptom)

        let second = JournalEntry(
            createdAt: yesterday,
            mood: .joyful,
            moodIntensity: 5,
            note: "Déjeuner avec une amie et longue promenade. J’ai eu beaucoup d’énergie."
        )

        let third = JournalEntry(
            createdAt: twoDaysAgo,
            mood: .tired,
            moodIntensity: 2,
            note: "Journée dense. Je vais essayer de me coucher plus tôt ce soir."
        )
        let medication = HealthEvent(
            date: twoDaysAgo,
            kind: .medication,
            title: "Vitamine D",
            note: "Prise après le petit-déjeuner.",
            dosage: "1 gélule",
            entry: third
        )
        third.healthEvents.append(medication)

        context.insert(first)
        context.insert(second)
        context.insert(third)
        try? context.save()
    }
}
