import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.symbolName)
                .font(.system(size: 56))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            Text(viewModel.cityName)
                .font(.largeTitle.bold())
            Text(viewModel.message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle(viewModel.title)
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
