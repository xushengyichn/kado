import SwiftUI
import KadoCore

/// Select any Home Screen icon. System failures restore the previous pick.
struct AppIconSection: View {
    @AppStorage(AppIconDefaults.key) private var icon: AppIcon = AppIconDefaults.defaultValue
    @Environment(\.appIconApplier) private var applier
    @State private var isApplying = false
    @State private var failureMessage: String?

    var body: some View {
        if applier.switcher.supportsAlternateIcons {
            AppIconPicker(selection: icon, isApplying: isApplying, onPick: pick)
                .alert("Couldn't change the icon", isPresented: Binding(
                    get: { failureMessage != nil },
                    set: { if !$0 { failureMessage = nil } }
                ), presenting: failureMessage) { _ in
                    Button("OK") {}
                } message: { message in
                    Text(verbatim: message)
                }
        }
    }

    private func pick(_ picked: AppIcon) {
        guard !isApplying else { return }
        let previous = icon
        icon = picked
        isApplying = true
        let applier = self.applier
        Task {
            defer { isApplying = false }
            do { try await applier.apply(preferred: picked) }
            catch {
                icon = previous
                failureMessage = error.localizedDescription
            }
        }
    }
}

private struct AppIconPicker: View {
    let selection: AppIcon
    let isApplying: Bool
    let onPick: (AppIcon) -> Void

    var body: some View {
        Section {
            ForEach(AppIcon.allCases, id: \.self) { option in
                Button { onPick(option) } label: {
                    AppIconRow(icon: option, isSelected: option == selection)
                }
                .disabled(isApplying)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(verbatim: "\(option.displayName), ") + Text(option.subtitle))
                .accessibilityAddTraits(option == selection ? [.isButton, .isSelected] : .isButton)
                .accessibilityIdentifier(AccessibilityID.Settings.appIconRow(option.rawValue))
            }
        } header: {
            Text("App icon").foregroundStyle(Color.kadoForegroundSecondary)
        } footer: {
            Text("The icon on your Home Screen. Each one follows Light, Dark and Tinted.")
                .foregroundStyle(Color.kadoForegroundSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .listRowBackground(Color.kadoBackgroundSecondary)
    }
}

private struct AppIconRow: View {
    let icon: AppIcon
    let isSelected: Bool

    /// Grows with Dynamic Type, but stops short of crowding the name
    /// out of the row at the accessibility sizes.
    @ScaledMetric(relativeTo: .body) private var scaledSide = 48.0
    private var side: CGFloat { min(scaledSide, 80) }

    var body: some View {
        HStack(spacing: 14) {
            let shape = RoundedRectangle(cornerRadius: side * 0.2237, style: .continuous)
            Image(icon.previewImageName)
                .resizable()
                .frame(width: side, height: side)
                .clipShape(shape)
                // The paper icons sit on a paper-coloured row; a hairline
                // keeps their edge.
                .overlay(shape.strokeBorder(Color.primary.opacity(0.12), lineWidth: 0.5))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: icon.displayName)
                    .foregroundStyle(Color.kadoForeground)
                Text(icon.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.kadoForegroundSecondary)
            }
            Spacer(minLength: 8)
            if isSelected {
                Image(systemName: "checkmark")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.kadoAccent)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}

extension AppIcon {
    /// The icon's name. Romanised Japanese, like the app's own, so it
    /// reads the same in every language — only ``subtitle`` translates.
    var displayName: String {
        switch self {
        case .kado: "Kadō"
        case .ura: "Ura"
        case .sakura: "Sakura"
        case .momiji: "Momiji"
        case .yuyake: "Yūyake"
        case .umi: "Umi"
        case .hotaru: "Hotaru"
        case .fuji: "Fuji"
        }
    }

    /// What the name means, under it in the row.
    var subtitle: LocalizedStringKey {
        switch self {
        case .kado: "The original"
        case .ura: "Kadō, inverted"
        case .sakura: "Cherry blossom"
        case .momiji: "Autumn maple"
        case .yuyake: "Sunset"
        case .umi: "Sea"
        case .hotaru: "Firefly"
        case .fuji: "Wisteria"
        }
    }
}


private struct AppIconSectionPreview: View {
    @State var selection: AppIcon
    var body: some View {
        Form { AppIconPicker(selection: selection, isApplying: false) { selection = $0 } }
            .scrollContentBackground(.hidden)
            .background(Color.kadoBackground.ignoresSafeArea())
    }
}
#Preview { AppIconSectionPreview(selection: .yuyake) }
#Preview("Dark") { AppIconSectionPreview(selection: .ura).preferredColorScheme(.dark) }
#Preview("Dynamic Type XXXL") {
    AppIconSectionPreview(selection: .kado).environment(\.dynamicTypeSize, .accessibility3)
}
