import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 56))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            Text("London")
                .font(.largeTitle.bold())
            Text("The forecast will appear on this screen.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("London Weather")
    }
}

#Preview {
    let store = Store(route: .homeView)
    let dependencies = AppDependencies()
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(store: store, dependencies: dependencies)
        )
    }
}
