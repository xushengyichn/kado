import XCTest

/// Verify Chinese navigation and unrestricted palettes on a real app launch.
final class ChineseFreeEditionTests: KadoUITestCase {
    @MainActor
    func testChineseScreensAndEveryPalette() {
        let app = launchApp(seedProduction: true, language: "zh-Hans", locale: "zh_CN", seedForScreenshots: true)
        XCTAssertTrue(app.staticTexts["今天"].firstMatch.waitForExistence(timeout: 10))
        capture(app, "chinese-today")
        tapTab(.overview, in: app)
        capture(app, "chinese-overview")
        tapTab(.settings, in: app)
        XCTAssertTrue(app.staticTexts["本地存储"].firstMatch.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Support Kadō"].exists)
        capture(app, "chinese-settings")
        let appearance = app.descendants(matching: .any)
            .matching(identifier: AccessibilityID.Settings.appearanceRow).firstMatch
        scrollTo(appearance, in: app)
        appearance.tap()
        for theme in ["kado", "classic", "muted", "vivid", "autumn", "monochromeSage"] {
            let row = app.descendants(matching: .any)
                .matching(identifier: AccessibilityID.Settings.habitThemeRow(theme)).firstMatch
            scrollTo(row, in: app)
            scrollClearOfTabBar(row, in: app)
            row.tap()
            let selected = expectation(for: NSPredicate(format: "isSelected == true"), evaluatedWith: row)
            wait(for: [selected], timeout: 5)
        }
        capture(app, "chinese-appearance")
        let icon = app.descendants(matching: .any)
            .matching(identifier: AccessibilityID.Settings.appIconRow("fuji")).firstMatch
        scrollTo(icon, in: app)
        scrollClearOfTabBar(icon, in: app)
        XCTAssertTrue(icon.exists)
        capture(app, "chinese-icons")
    }
}
