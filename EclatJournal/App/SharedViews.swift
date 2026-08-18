import SwiftUI

struct SectionCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(Color.secondary.opacity(0.09), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct MoodBadge: View {
    let mood: Mood
    var intensity: Int? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text(mood.emoji)
            Text(mood.label)
            if let intensity {
                Text(String(repeating: "●", count: max(1, intensity)))
                    .font(.caption2)
                    .foregroundStyle(mood.tint)
                    .accessibilityLabel("Intensité \(intensity) sur 5")
            }
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(mood.tint.opacity(0.12), in: Capsule())
        .accessibilityElement(children: .combine)
    }
}

struct EmptyState: View {
    let title: String
    let symbol: String
    let description: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: symbol)
        } description: {
            Text(description)
        } actions: {
            if let actionTitle, let action {
                Button(actionTitle, action: action)
            }
        }
    }
}
