import SwiftUI

@main
struct LondonWeatherApp: App {
    private let store: Store

    init() {
        store = Store(route: .homeView)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
