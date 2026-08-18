import XCTest
@testable import EclatJournal

final class EclatJournalTests: XCTestCase {
    func testMantraCatalogContainsOriginalReflections() {
        XCTAssertGreaterThanOrEqual(MantraCatalog.all.count, 10)
        XCTAssertFalse(MantraCatalog.all.contains { $0.text.isEmpty })
    }
}
