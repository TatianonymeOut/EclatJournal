import Foundation
import XCTest

@testable import EclatJournal

final class JournalInsightsTests: XCTestCase {
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testMoodCountsIncludesEveryMoodInDisplayOrder() {
        let entries = [
            entry(mood: .joyful, intensity: 5, day: 2),
            entry(mood: .joyful, intensity: 4, day: 2),
            entry(mood: .sad, intensity: 2, day: 3),
        ]

        let counts = JournalInsights.moodCounts(for: entries)

        XCTAssertEqual(counts.map(\.mood), Mood.allCases)
        XCTAssertEqual(counts.map(\.count), [2, 0, 0, 0, 1, 0, 0])
    }

    func testActiveDaysCountsEachCalendarDayOnlyOnce() {
        let entries = [
            entry(mood: .calm, intensity: 4, day: 4, hour: 8),
            entry(mood: .tired, intensity: 2, day: 4, hour: 19),
            entry(mood: .neutral, intensity: 3, day: 5),
        ]

        XCTAssertEqual(JournalInsights.activeDays(for: entries, calendar: calendar), 2)
    }

    func testMoodDaysGroupsSortsAndSummarizesEntriesByDay() {
        let entries = [
            entry(mood: .tired, intensity: 2, day: 8),
            entry(mood: .joyful, intensity: 5, day: 7, hour: 9),
            entry(mood: .joyful, intensity: 3, day: 7, hour: 20),
            entry(mood: .sad, intensity: 1, day: 7, hour: 21),
        ]

        let days = JournalInsights.moodDays(for: entries, calendar: calendar)

        XCTAssertEqual(days.map(\.date), [startOfDay(7), startOfDay(8)])
        XCTAssertEqual(days.map(\.mood), [.joyful, .tired])
        XCTAssertEqual(days.map(\.averageIntensity), [3, 2])
    }

    func testInsightsHandleNoEntries() {
        XCTAssertEqual(JournalInsights.moodCounts(for: []).map(\.count), Array(repeating: 0, count: Mood.allCases.count))
        XCTAssertEqual(JournalInsights.activeDays(for: [], calendar: calendar), 0)
        XCTAssertTrue(JournalInsights.moodDays(for: [], calendar: calendar).isEmpty)
    }

    private func entry(mood: Mood, intensity: Int, day: Int, hour: Int = 12) -> JournalEntry {
        JournalEntry(
            createdAt: date(day: day, hour: hour),
            mood: mood,
            moodIntensity: intensity
        )
    }

    private func date(day: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 8, day: day, hour: hour))!
    }

    private func startOfDay(_ day: Int) -> Date {
        calendar.startOfDay(for: date(day: day))
    }
}
