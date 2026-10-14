import Testing
import Foundation
@testable import Kado

@Suite("TodayCard")
struct TodayCardTests {
    @Test("An announcement is shown until it is retired")
    func announcement() {
        #expect(TodayCard.resolve(announcementRetiredAt: nil) == .appearanceAnnouncement)
    }
    @Test("Dismissing the announcement never reveals a payment prompt")
    func retired() {
        #expect(TodayCard.resolve(announcementRetiredAt: .distantPast) == nil)
        #expect(TodayCard.resolve(announcementRetiredAt: .now) == nil)
    }
}
