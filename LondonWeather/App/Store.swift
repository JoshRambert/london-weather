import SwiftUI

@MainActor
@Observable
public final class Store {
    public private(set) var route: Route
    public var modal: ModalRoute?
    public var homePath = NavigationPath()
    public private(set) var homeRefreshGeneration: UInt = 0
    public private(set) var errorAlert: ErrorAlert?

    public struct ErrorAlert: Identifiable {
        public let id = UUID()
        public let message: String
        public let retryAction: (() async -> Void)?
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

    public func clearNavigationState() {
        homePath = NavigationPath()
        modal = nil
        errorAlert = nil
    }

    public func notifyHomeToRefresh() {
        homeRefreshGeneration &+= 1
    }

    public func popToHomeScreen() {
        homePath = NavigationPath()
    }

    public func presentErrorAlert(_ message: String, retryAction: (() async -> Void)? = nil) {
        errorAlert = ErrorAlert(message: message, retryAction: retryAction)
    }

    public func dismissErrorAlert() {
        errorAlert = nil
    }
}
