import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private let store: Store

    private(set) var title = "London Weather"
    private(set) var cityName = "London"
    private(set) var symbolName = "cloud.sun"
    private(set) var message = "The forecast will appear on this screen."

    init(store: Store) {
        self.store = store
    }
}
