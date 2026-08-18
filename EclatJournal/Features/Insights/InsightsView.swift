import Charts
import SwiftData
import SwiftUI

struct InsightsView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]

    private var moodCounts: [MoodCount] {
        JournalInsights.moodCounts(for: entries).filter { $0.count > 0 }
    }

    private var moodDays: [MoodDay] {
        Array(JournalInsights.moodDays(for: entries).suffix(14))
    }

    private var mostFrequentMood: Mood? {
        moodCounts.max(by: { $0.count < $1.count })?.mood
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if entries.isEmpty {
                    EmptyState(
                        title: "Les tendances apparaîtront ici",
                        symbol: "chart.xyaxis.line",
                        description: "Lorsque tu auras quelques entrées, Éclat affichera des repères simples sur tes humeurs."
                    )
                    .frame(minHeight: 380)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            InsightMetric(
                                value: "\(JournalInsights.activeDays(for: entries))",
                                label: "jours notés",
                                symbol: "calendar"
                            )
                            if let mostFrequentMood {
                                InsightMetric(
                                    value: mostFrequentMood.emoji,
                                    label: mostFrequentMood.label,
                                    symbol: "face.smiling"
                                )
                            }
                        }

                        SectionCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Label("Humeur sur les 14 derniers jours", systemImage: "chart.line.uptrend.xyaxis")
                                    .font(.headline)

                                if moodDays.count > 1 {
                                    Chart(moodDays) { day in
                                        LineMark(
                                            x: .value("Jour", day.date),
                                            y: .value("Intensité", day.averageIntensity)
                                        )
                                        .foregroundStyle(.tint)
                                        .interpolationMethod(.catmullRom)

                                        PointMark(
                                            x: .value("Jour", day.date),
                                            y: .value("Intensité", day.averageIntensity)
                                        )
                                        .foregroundStyle(day.mood.tint)
                                    }
                                    .chartYScale(domain: 1 ... 5)
                                    .chartXAxis {
                                        AxisMarks(values: .stride(by: .day, count: 2)) {
                                            AxisGridLine()
                                            AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
                                        }
                                    }
                                    .frame(height: 210)
                                } else {
                                    Text("Ajoute au moins une autre entrée pour visualiser une évolution.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .frame(height: 120, alignment: .leading)
                                }
                            }
                        }

                        SectionCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Label("Répartition des humeurs", systemImage: "chart.bar")
                                    .font(.headline)

                                Chart(moodCounts) { count in
                                    BarMark(
                                        x: .value("Nombre", count.count),
                                        y: .value("Humeur", count.mood.label)
                                    )
                                    .foregroundStyle(count.mood.tint.gradient)
                                    .annotation(position: .trailing) {
                                        Text("\(count.count)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .frame(height: max(160, CGFloat(moodCounts.count) * 40))
                            }
                        }

                        Text("Ces tendances sont des repères personnels. Elles ne constituent pas une analyse médicale.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: 760, alignment: .leading)
                }
            }
            .navigationTitle("Tendances")
        }
    }
}

private struct InsightMetric: View {
    let value: String
    let label: String
    let symbol: String

    var body: some View {
        SectionCard {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(.title3.bold())
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
