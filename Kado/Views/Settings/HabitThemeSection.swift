import SwiftUI
import KadoCore

/// All habit palettes are directly available.
struct HabitThemeSection: View {
    @AppStorage(HabitThemeDefaults.key, store: HabitThemeDefaults.sharedDefaults)
    private var theme: HabitTheme = HabitThemeDefaults.defaultValue

    var body: some View {
        HabitThemePicker(theme: $theme)
    }
}

private struct HabitThemePicker: View {
    @Binding var theme: HabitTheme

    var body: some View {
        Section {
            ForEach(HabitTheme.allCases, id: \.self) { option in
                Button { theme = option } label: {
                    HabitThemeRow(theme: option, isSelected: option == theme)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(option.name))
                .accessibilityAddTraits(option == theme ? [.isButton, .isSelected] : .isButton)
                .accessibilityIdentifier(AccessibilityID.Settings.habitThemeRow(option.rawValue))
            }
        } header: {
            Text("Habit colours").foregroundStyle(Color.kadoForegroundSecondary)
        } footer: {
            Text("Recolours every habit, here and in widgets. Each habit keeps its colour; the theme decides how it looks.")
                .foregroundStyle(Color.kadoForegroundSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .listRowBackground(Color.kadoBackgroundSecondary)
    }
}

private struct HabitThemeRow: View {
    let theme: HabitTheme
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(theme.name).foregroundStyle(Color.kadoForeground)
                HStack(spacing: 6) {
                    ForEach(HabitColor.allCases, id: \.self) { color in
                        Circle().fill(color.color(in: theme)).frame(width: 18, height: 18)
                    }
                }
            }
            Spacer(minLength: 8)
            if isSelected {
                Image(systemName: "checkmark").fontWeight(.semibold).foregroundStyle(Color.kadoAccent)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}

extension HabitTheme {
    /// The theme's display name, shared by the picker rows and the
    /// Appearance row in Settings.
    var name: LocalizedStringKey {
        switch self {
        case .kado: "Kadō"
        case .classic: "Classic"
        case .muted: "Muted"
        case .vivid: "Vivid"
        case .autumn: "Autumn"
        case .monochromeSage: "Monochrome sage"
        }
    }
}


private struct HabitThemeSectionPreview: View {
    @State var theme: HabitTheme
    var body: some View {
        Form { HabitThemePicker(theme: $theme) }
            .scrollContentBackground(.hidden)
            .background(Color.kadoBackground.ignoresSafeArea())
    }
}
#Preview { HabitThemeSectionPreview(theme: .autumn) }
#Preview("Dark") {
    HabitThemeSectionPreview(theme: .monochromeSage).preferredColorScheme(.dark)
}
#Preview("Dynamic Type XXXL") {
    HabitThemeSectionPreview(theme: .vivid).environment(\.dynamicTypeSize, .accessibility3)
}
