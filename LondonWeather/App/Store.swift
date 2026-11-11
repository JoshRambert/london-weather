import SwiftUI

@MainActor
@Observable
public final class Store {
    public private(set) var route: Route
    public var modal: ModalRoute?
    public var bottomSheet: BottomSheetRoute?
    public var homePath = NavigationPath()
    public private(set) var homeRefreshGeneration: UInt = 0

    private var pendingSheetActions: PendingSheetActions = .none
    private var stagedSheetDismissAction: (() async -> Void)?

    private enum PendingSheetActions {
        case none
        case errorRetry(() async -> Void)
    }

    public init(route: Route) {
        self.route = route
    }

    public func toRoute(_ route: Route) {
        self.route = route
    }

    public func presentModal(_ modalRoute: ModalRoute) async {
        modal = modalRoute
    }

    public func dismissModal() {
        modal = nil
    }

    public func dismissBottomSheet() {
        pendingSheetActions = .none
        stagedSheetDismissAction = nil
        bottomSheet = nil
    }

    public func clearNavigationState() {
        homePath = NavigationPath()
        modal = nil
        dismissBottomSheet()
    }

    public func notifyHomeToRefresh() {
        homeRefreshGeneration &+= 1
    }

    public func popToHomeScreen() {
        homePath = NavigationPath()
    }

    public func presentErrorSheet(_ message: String, retryAction: (() async -> Void)? = nil) {
        pendingSheetActions = retryAction.map(PendingSheetActions.errorRetry) ?? .none
        bottomSheet = .errorSheet(message, canRetry: retryAction != nil)
    }

    public func confirmPendingErrorRetryAction() {
        if case .errorRetry(let retryAction) = pendingSheetActions {
            stagedSheetDismissAction = retryAction
        }
        pendingSheetActions = .none
        bottomSheet = nil
    }

    public func runStagedSheetActionOnDismiss() async {
        pendingSheetActions = .none
        guard let action = stagedSheetDismissAction else { return }
        stagedSheetDismissAction = nil
        await action()
    }
}
