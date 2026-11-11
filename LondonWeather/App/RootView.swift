import SwiftUI

struct RootView: View {
    @Environment(Store.self) private var store

    var body: some View {
        @Bindable var store = store

        root
            .fullScreenCover(item: $store.modal) { _ in
                EmptyView()
            }
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
    private var root: some View {
        @Bindable var store = store

        switch store.route {
        case .homeView:
            NavigationStack(path: $store.homePath) {
                HomeView(
                    viewModel: HomeViewModel(store: store)
                )
                .navigationDestination(for: HomeNavigation.self) { _ in
                    EmptyView()
                }
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
