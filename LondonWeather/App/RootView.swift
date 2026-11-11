import SwiftUI

struct RootView: View {
    @Environment(Store.self) private var store
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        @Bindable var store = store

        content
            .fullScreenCover(item: $store.modal) { _ in }
            .alert(
                "London Weather",
                isPresented: errorAlertIsPresented,
                presenting: store.errorAlert
            ) { alert in
                Button("OK", role: .cancel) {}
                if let retryAction = alert.retryAction {
                    Button("Try Again") {
                        Task { await retryAction() }
                    }
                }
            } message: { alert in
                Text(alert.message)
            }
    }

    @ViewBuilder
    private var content: some View {
        @Bindable var store = store

        switch store.route {
        case .homeView:
            NavigationStack(path: $store.homePath) {
                HomeHostingView(
                    store: store,
                    weatherService: dependencies.weatherService
                )
                .navigationDestination(for: HomeNavigation.self) { _ in }
            }
        }
    }

    private var errorAlertIsPresented: Binding<Bool> {
        Binding(
            get: { store.errorAlert != nil },
            set: { isPresented in
                if !isPresented {
                    store.dismissErrorAlert()
                }
            }
        )
    }
}
