import SwiftUI

struct RootView: View {
    @Environment(Store.self) private var store
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        @Bindable var store = store
        let sheetCoordinator = RootBottomSheetCoordinator(store: store)

        root
            .fullScreenCover(item: $store.modal) { _ in
                EmptyView()
            }
            .sheet(item: $store.bottomSheet, onDismiss: {
                Task { await store.runStagedSheetActionOnDismiss() }
            }) { route in
                switch route {
                case .errorSheet(let message, let canRetry):
                    ErrorBottomSheet(
                        message: message,
                        canRetry: canRetry,
                        dismiss: sheetCoordinator.makeDismissBottomSheetAction(),
                        retry: sheetCoordinator.makeErrorRetryAction()
                    )
                }
            }
    }

    @ViewBuilder
    private var root: some View {
        @Bindable var store = store

        switch store.route {
        case .homeView:
            NavigationStack(path: $store.homePath) {
                HomeView(
                    viewModel: HomeViewModel(store: store, dependencies: dependencies)
                )
                .navigationDestination(for: HomeNavigation.self) { _ in
                    EmptyView()
                }
            }
        }
    }
}
