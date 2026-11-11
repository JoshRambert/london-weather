import SwiftUI

@main
struct LondonWeatherApp: App {
    @State private var store = Store(route: .homeView)
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(dependencies)
        }
    }
}
