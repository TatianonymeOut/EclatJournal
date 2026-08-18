import Foundation
import XCTest

@testable import EclatJournal

final class DailyMantraTests: XCTestCase {
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testMantraUsesSameSelectionForEveryMomentOfOneDay() {
        let morning = date(year: 2026, month: 8, day: 18, hour: 8)
        let evening = date(year: 2026, month: 8, day: 18, hour: 21)

        XCTAssertEqual(
            MantraCatalog.mantra(for: morning, calendar: calendar),
            MantraCatalog.mantra(for: evening, calendar: calendar)
        )
    }

    func testMantraSelectionStartsWithFirstCatalogItemOnFirstDayOfYear() {
        let firstDayOfYear = date(year: 2026, month: 1, day: 1)

        XCTAssertEqual(
            MantraCatalog.mantra(for: firstDayOfYear, calendar: calendar),
            MantraCatalog.all[0]
        )
    }

    func testMantraSelectionCyclesAfterCatalogLength() {
        let firstDay = date(year: 2026, month: 1, day: 1)
        let firstDayOfSecondCycle = date(year: 2026, month: 1, day: MantraCatalog.all.count + 1)

        XCTAssertEqual(
            MantraCatalog.mantra(for: firstDayOfSecondCycle, calendar: calendar),
            MantraCatalog.mantra(for: firstDay, calendar: calendar)
        )
    }

    private func date(year: Int, month: Int, day: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }
}
