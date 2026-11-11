import SwiftUI

@main
struct LondonWeatherApp: App {
    private let store: Store
    private let dependencies: AppDependencies

    init() {
        store = Store(route: .homeView)
        dependencies = AppDependencies()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(dependencies)
        }
    }
}
