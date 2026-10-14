import SwiftUI
import KadoCore

/// Choose any habit palette and app icon; all options are available.
struct AppearanceView: View {
    @Environment(\.appearanceAnnouncement) private var appearanceAnnouncement

    var body: some View {
        Form {
            HabitThemeSection()
            AppIconSection()
        }
        .scrollContentBackground(.hidden)
        .background(Color.kadoBackground.ignoresSafeArea())
        .navigationTitle("Appearance")
        .onAppear { appearanceAnnouncement.retire() }
    }
}

#Preview { NavigationStack { AppearanceView() } }
#Preview("Dark") {
    NavigationStack { AppearanceView() }.preferredColorScheme(.dark)
}
