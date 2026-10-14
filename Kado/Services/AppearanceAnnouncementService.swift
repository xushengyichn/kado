import Foundation

/// Keys the Appearance announcement owns in `UserDefaults`, named here
/// so the UI-test hooks can seed and clear them. Mirrors
nonisolated enum AppearanceAnnouncementDefaults {
    /// When the card was put away: dismissed, or Appearance opened by
    /// any route. Absent means still due.
    static let retiredAt = "kado.appearanceAnnouncement.retiredAt"

    static let allKeys = [retiredAt]
}

/// Decides whether Today announces Settings › Appearance (habit colour
///

/// everyone who updates, so it is due from the first launch. It goes
/// for good the first time it is dismissed or Appearance is opened —
/// the user has either declined or found it. The date it went is kept,

/// (`TodayCard`).
///

/// a dismissal flag isn't worth a CloudKit schema version.
protocol AppearanceAnnouncing: Sendable {
    /// When the card was put away, or `nil` while it is still due.
    func retiredAt() -> Date?
    /// Put the card away for good. The first call's date sticks.
    func retire()
}

/// Production ``AppearanceAnnouncing``, backed by `UserDefaults`.
struct DefaultAppearanceAnnouncementService: AppearanceAnnouncing, Sendable {
    private let defaults: UserDefaults
    private let now: @Sendable () -> Date

    init(
        defaults: UserDefaults = .standard,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.defaults = defaults
        self.now = now
    }

    func retiredAt() -> Date? {
        defaults.object(forKey: AppearanceAnnouncementDefaults.retiredAt) as? Date
    }

    func retire() {
        guard retiredAt() == nil else { return }
        defaults.set(now(), forKey: AppearanceAnnouncementDefaults.retiredAt)
    }
}
