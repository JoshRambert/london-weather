import SwiftUI

@main
struct LondonWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherScreen(reading: .londonSample)
        }
    }
}
