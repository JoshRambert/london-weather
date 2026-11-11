import Foundation

@MainActor
final class RootBottomSheetCoordinator {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func makeDismissBottomSheetAction() -> () -> Void {
        { [store] in store.dismissBottomSheet() }
    }

    func makeErrorRetryAction() -> () -> Void {
        { [store] in store.confirmPendingErrorRetryAction() }
    }
}
