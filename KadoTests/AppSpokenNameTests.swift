import Foundation
import Testing
@testable import Kado
import KadoCore

/// Pins the plain-ASCII names Siri can match the app by (issue #108).
///
/// Siri on visionOS 26 transcribes "Open Kadō" with the macron and then
/// reports no app by that name: matching an app whose display name
/// carries a diacritic fails, both for "Open …" and for App Shortcut
/// phrases built on `\(.applicationName)`. `Kado/Info.plist` declares
/// "Kado" as the spoken name and as an alternative app name — which
/// App Shortcuts also accept for `.applicationName` — and this suite
/// fails if either drops out of the merged Info.plist or stops being
/// the display name with its diacritics folded away.
@Suite("App spoken name")
struct AppSpokenNameTests {

    private var info: [String: Any] { Bundle.main.infoDictionary ?? [:] }

    @Test("The personal edition has a distinct display name")
    func displayNameIsKado() {
        #expect(info["CFBundleDisplayName"] as? String ==
            (SharedStore.offlineOnly ? "Kadō 离线版" : "Kadō"))
    }

    @Test("The spoken name stays easy for Siri to recognize")
    func spokenNameIsFolded() throws {
        let spoken = try #require(info["CFBundleSpokenName"] as? String)
        #expect(spoken == "Kado")
        #expect(spoken.allSatisfy { $0.isASCII })
    }

    @Test("Kado remains an alternative app name")
    func alternativeNameIsFolded() throws {
        let entries = try #require(info["INAlternativeAppNames"] as? [[String: Any]])
        let names = entries.compactMap { $0["INAlternativeAppName"] as? String }
        #expect(names.contains("Kado"))
        #expect(names.allSatisfy { name in name.allSatisfy { $0.isASCII } })
    }
}
