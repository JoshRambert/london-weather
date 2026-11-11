import Foundation

struct CurrentConditionsDetails: Equatable {
    let temperature: String
    let feelsLikeTemperature: String
    let conditions: String
    let windSpeed: String
}

@MainActor
@Observable
final class HomeViewModel {
    
    enum State: Equatable {
        case loading
        case loaded(
            resolvedAddress: String,
            currentConditions: CurrentConditionsDetails,
            forecastDays: [Day.Forecast]
        )
        case error
    }

    private let store: Store
    private let weatherService: any WeatherService
    private var requestID = 0

    private(set) var state: State = .loading
    var temperatureUnit: WeatherUnitGroup = .metric

    init(store: Store, weatherService: any WeatherService) {
        self.store = store
        self.weatherService = weatherService
    }

    func loadCurrentWeather() async {
        requestID += 1
        let activeRequestID = requestID
        state = .loading

        let unitGroup = temperatureUnit

        do {
            let weather = try await weatherService.currentLondonWeather(unitGroup: unitGroup)
            guard activeRequestID == self.requestID else { return }
            let conditions = weather.currentConditions
            state = .loaded(
                resolvedAddress: weather.resolvedAddress,
                currentConditions: CurrentConditionsDetails(
                    temperature: unitGroup.temperatureText(for: conditions.temp),
                    feelsLikeTemperature: unitGroup.temperatureText(for: conditions.feelsLike),
                    conditions: conditions.conditions,
                    windSpeed: unitGroup.windSpeedText(for: conditions.windSpeed)
                ),
                forecastDays: weather.forecastDays(unitGroup: unitGroup)
            )
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            guard activeRequestID == self.requestID else { return }
            state = .error
            store.presentErrorAlert(
                (error as? LocalizedError)?.errorDescription ?? "The current weather could not be loaded.",
                retryAction: { [weak self] in
                    await self?.loadCurrentWeather()
                }
            )
        }
    }
}
