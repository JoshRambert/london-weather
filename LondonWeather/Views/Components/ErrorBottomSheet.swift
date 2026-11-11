import SwiftUI

struct ErrorBottomSheet: View {
    let message: String
    let canRetry: Bool
    let dismiss: () -> Void
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Something went wrong")
                .font(.title2.bold())
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if canRetry {
                Button("Try Again", action: retry)
                    .buttonStyle(.borderedProminent)
            }
            Button("Dismiss", action: dismiss)
                .buttonStyle(.bordered)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
