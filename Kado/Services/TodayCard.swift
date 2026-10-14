import Foundation

/// Today's optional announcement has no purchase or donation prompt.
nonisolated enum TodayCard: Equatable {
    case appearanceAnnouncement

    static func resolve(announcementRetiredAt: Date?) -> TodayCard? {
        announcementRetiredAt == nil ? .appearanceAnnouncement : nil
    }
}
