import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private let store: Store
    private let dependencies: AppDependencies

    private(set) var title = "London Weather"
    private(set) var cityName = "London"
    private(set) var symbolName = "cloud.sun"
    private(set) var message = "The forecast will appear on this screen."

    init(store: Store, dependencies: AppDependencies) {
        self.store = store
        self.dependencies = dependencies
    }
}
