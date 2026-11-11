import Foundation

@MainActor
@Observable
final class AppDependencies {
    let weatherService: any WeatherService

    init(weatherService: any WeatherService = LiveWeatherService()) {
        self.weatherService = weatherService
    }
}
