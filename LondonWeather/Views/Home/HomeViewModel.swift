import Foundation
import os

@MainActor
@Observable
final class HomeViewModel {
    private let store: Store
    private let weatherService: any WeatherService
    private var isLoading = false

    private(set) var title = "London Weather"
    private(set) var cityName = "London"
    private(set) var symbolName = "cloud.sun"
    private(set) var message = "The forecast will appear on this screen."

    init(store: Store, weatherService: any WeatherService) {
        self.store = store
        self.weatherService = weatherService
    }

    func loadCurrentWeather() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let weather = try await weatherService.currentWeather(forCity: cityName)
            let conditions = weather.currentConditions
            let temperature = Int(conditions.temp.rounded())
            message = "\(temperature)\(weatherService.unitGroup.temperatureSuffix) · \(conditions.conditions)"
            symbolName = systemImageName(forVisualCrossingIcon: conditions.icon)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "LondonWeather", category: "Weather")
                .error("Current weather failed: \(error.localizedDescription, privacy: .public)")
            store.presentErrorAlert(
                errorMessage(for: error),
                retryAction: { [weak self] in
                    await self?.loadCurrentWeather()
                }
            )
        }
    }

    private func errorMessage(for error: Error) -> String {
        if let weatherError = error as? WeatherServiceError {
            return weatherError.localizedDescription
        }
        return "The current weather could not be loaded."
    }

    private func systemImageName(forVisualCrossingIcon icon: String) -> String {
        switch icon {
        case "clear-day":
            "sun.max"
        case "clear-night":
            "moon.stars"
        case "partly-cloudy-day":
            "cloud.sun"
        case "partly-cloudy-night":
            "cloud.moon"
        case "cloudy":
            "cloud"
        case "fog":
            "cloud.fog"
        case "wind":
            "wind"
        case "rain":
            "cloud.rain"
        case "snow":
            "snowflake"
        default:
            if icon.contains("thunder") {
                "cloud.bolt.rain"
            } else if icon.contains("snow") {
                "snowflake"
            } else if icon.contains("rain") || icon.contains("showers") {
                "cloud.rain"
            } else {
                "cloud.sun"
            }
        }
    }
}
