import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private let store: Store
    private let dependencies: AppDependencies

    init(store: Store, dependencies: AppDependencies) {
        self.store = store
        self.dependencies = dependencies
    }
}
